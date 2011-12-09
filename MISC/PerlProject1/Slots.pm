package Slots;
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(SIGNAL SLOT PROVIDE CONNECT DISCONNECT EMIT INHERIT DUMMY);

use Scalar::Util qw(refaddr blessed);

INIT {
    my %p =();  # über PROVIDED bereitgestellte Signale und Slots
    my %c =();  # über CONNECT erzeugte Verbindungen
    
    
    # Im Hash %p werden für die definierten Signal / Slots
    # folgende Daten gespeichert :
    # <Klasse>__<Typ>__<Name> => Referenz auf Unterprogramm
    
    sub set_provided        { $p{$_[0]} = $_[1]; }
    sub get_provided        { return $p{$_[0]}; }
    sub  is_provided        { return exists $p{$_[0]}; }
    sub get_ref_provided    { return \%p; }
    
    # Im Hash %c werden die Verbindungsdaten gespeichert für die
    # einzelnen Signale in folgender Form gespeichert :
    # <ID Obj>__<Klasse>__<Typ>__<Name> => Referenz auf Array
    #
    # Inhalt Array :    verbundenes Objekt,
    #                   Schlüssel verbundener SLOT bzw. SIGNAL (in %p)
    #                   Typ (SLOT bzw SIGNAL)
    #                   Name des SLOTs bzw. SIGNALs
    
    sub init_connections    { return $c{$_[0]} ||= []; }
    sub  get_connections    { return $c{$_[0]}; }
    
    # Hier werden die Schlüssel für
    #%p (_get_class_key) und %c (_get_object_key) erzeugt
    
    sub _get_class_key      { return sprintf('%s__%s__%s',@_); }
    sub _get_object_key     {
        return sprintf('%s__%s__%s__%s', refaddr($_[0]), ref($_[0]), $_[1], $_[2]);
    }
    
    # Testet die Parameter für CONNECT bzw DISCONNECT
    #
    # Aufruf CONNECT $obj1, SIGNAL,           <Name1>,
    #                $obj2, SIGNAL bzw. SLOT, <Name2>
    
    sub _test_connect_para {
        die 'Erster Verbindungspartner kein Objekt'
            unless (blessed($_[0]));
        
        die 'Erster Verbindungspartner nicht vom Typ SIGNAL'
            if ($_[1] ne 'SIGNAL');
        
        die "Erster Verbindungspartner $_[2] nicht definiert"
            unless (is_provided(_get_class_key(ref($_[0]), $_[1], $_[2])));
        
        die 'Zweiter Verbindungspartner kein Objekt'
            unless (blessed($_[3]));
            
        die 'Zweiter Verbindungspartner nich vom Typ SLOT bzw. SIGNAL'
            if (($_[4] ne 'SIGNAL') and ($_[4] ne 'SLOT'));
        
        die "Zweiter Verbindungspartner $_[5] nicht definiert"
            unless (is_provided(_get_class_key(ref($_[3]), $_[4], $_[5])));
            
        return 1;
    }
            
}

# Liefern 'SIGNAL' bzw 'SLOT' zurück (spart die Anführungszeichen)
sub SIGNAL ()               { return 'SIGNAL'; }
sub SLOT ()                 { return 'SLOT'; }

# Erzeugt ein SIGNAL bzw. einen SLOT
# Aufruf : PROVIDE SIGNAL, <Name>
#          PROVIDE SLOT,   <Name>, &unterroutine
#
# &unterroutine wird als Referenzübergeben da Prototyp \&

sub PROVIDE ($$;\&)         {
    my ($typ, $name, $func) = @_;
    
    if      ($typ eq 'SIGNAL')  { $func = \&EMIT; }
    elsif   ($typ eq 'SLOT')    { die 'Funktion fehlt' unless($func);}
    else                        { die 'Typ werder SIGNAL noch SLOT'; }
    
    my $class = (caller(0))[0];
    my $c_key = _get_class_key($class, $typ, $name);
    
    set_provided($c_key, $func) unless (is_provided($c_key));
}

# Löst eine bestehende Verbindung
# Aufruf : DISCONNECT $obj1, SIGNAL,          <Name1>,
#                     $obj2, SIGNAL bzw SLOT, <Name2>

sub DISCONNECT ($$$$$$)     {
    my ($sig, $sig_typ, $sig_name, $slo, $slo_typ, $slo_name) = @_;
    
    _test_connect_para(@_);
    
    my $sig_o_key = _get_object_key($sig, $sig_typ, $sig_name);
    my $slo_c_key = _get_class_key(ref($slo), $slo_typ, $slo_name);
    
    my $connections = init_connections($sig_o_key);
    
    # alle Verbindungen behalten die nicht mit $slo ff identisch sind
    @$connections = grep { (($_->[0] != $slo) or ($_->[1] ne $slo_c_key)) }
                         ( @$connections );
                         
    return ($connections, $slo_c_key); # wird nur für CONNECT benötigt
}

# Erstellt eine Verbindung
# Aufruf : CONNECT $obj1, SIGNAL,          <Name1>,
#                  $obj2, SIGNAL bzw SLOT, <Name2>

sub CONNECT ($$$$$$)        {
    my ($sig, $sig_typ, $sig_name, $slo, $slo_typ, $slo_name) = @_;
    
    # eine eventuell bereits definierte Verbindung löschen
    my ($connections, $slo_c_key) = &DISCONNECT(@_);
    
    # neue Verbindung anlegen
    push @$connections, [$slo, $slo_c_key, $slo_typ, $slo_name];
}

# Vererbung von Slots und Signalen

sub INHERIT () {
    my $class = (caller(0))[0];
    my $pro = get_ref_provided();
    
    my $isa = $class . '::ISA';
    no strict; my @isa = @{$isa}; use strict;
    
    for my $base (@isa) {
        map  { my $base_key = $_;
              s/^$base/$class/;
              $pro->{$_} = $pro->{$base_key}; }
        grep { m/^$base/; } keys %$pro;
    }
}

# Löst ein Signal aus
# Aufruf : $obj->EMIT(<Name>, @optionale_Argumente)
#
# Da SIGNALE und SLOTS nur bei OOP Sinn machen, dürfte es
# kein Problem sein, dass das Objekt als erstes Argument
# übergeben wird.
# Die als SLOT definierten Unterprogramme müssen also
# sinngemäß folgenden Code aufweisen:
#
# sub { my $self = shift; ... }

sub EMIT ($$;@) {
    my ($obj, $name, @args) = @_;
    
    die 'Erstes Argument kein Objekt'
        unless (blessed($obj));
        
    die "$obj $name nicht als Signal definiert"
        unless (is_provided(_get_class_key(ref($obj),'SIGNAL', $name)));
        
    my $connections =
        get_connections(_get_object_key($obj, 'SIGNAL', $name));
        
    for my $data (@$connections) {
        my ($s_obj, $s_key, $s_typ, $s_name) = @$data;
        
        my $func = get_provided($s_key);
        my @para = ($s_typ eq 'SIGNAL') ? ($s_obj, $s_name) : ($s_obj);
        
        $func->(@para, @args);
    }
}

# Aufruf : DUMMY
# 
# Bei PROVIDE wird die Klasse mit eingetragen. Bei CONNECT wird diese
# abgefragt. Soll Slots von einem Modul aufgerufen werden, welches nicht
# objektorientiert ist, so braucht man trotzdem eine "blessed" Referenz.
# DUMMY liefert diese.

sub DUMMY () {
    my $class = (caller(0))[0];
    return bless \$class, $class;
}
1;

__END__

=head1 Slots

Slots - Signale und Slots analog zu Qt

=head2 Funktionen

=over Funktionen

=item SIGNAL

 Aufruf  : my $text = SIGNAL;
 Ergebnis: Liefert den String 'SIGNAL' zurueck.

 SIGNAL dient eigentlich nur dazu die Anfuehrungszeichen zu sparen.

=item SLOT

 Aufruf  : my $text = SLOT;
 Ergebnis: Liefert den String 'SLOT' zurueck.

 SLOT dient eigentlich nur dazu die Anfuehrungszeichen zu sparen.

=item PROVIDE

 Aufruf  : PROVIDE SIGNAL, <Name>;
           PROVIDE SLOT,   <Name>, &irgendeine_funktion;
 Ergebnis: keine Rueckgabe.

 PROVIDE definiert ein Signal oder einen SLOT fuer die aufrufende Klasse.

=item CONNECT

 Aufruf  : CONNECT $obj1, SIGNAL, <Name1>, $obj2, SLOT,   <Name2>;
         : CONNECT $obj1, SIGNAL, <Name1>, $obj2, SIGNAL, <Name2>;
 Ergebnis: keine Rueckgabe.
 
 CONNECT verbindet ein Signal des Objekt 1 mit einem Signal oder Slot
 des Objekt 2.

=item DISCONNECT

 Aufruf  : DISCONNECT $obj1, SIGNAL, <Name1>, $obj2, SLOT,   <Name2>;
           DISCONNECT $obj1, SIGNAL, <Name1>, $obj2, SIGNAL, <Name2>;
 Ergebnis: keine Rueckgabe.
 
 DISCONNECT loest eine mit CONNECT erstellte Verbindung.

=item INHERIT

 Aufruf  : INHERIT;
 Ergebnis: keine Rueckgabe;
 
 Signale und Slots werden von den Basisklassen geerbt;
 
=item EMIT

 Aufruf  : $obj->EMIT(<Name>, ?@args?);
 Ergebnis: keine Rueckgabe.
 
 EMIT sendet das fuer die Klasse des Objekts definierte Signal <Name>.
 Optional koennen weitere Parameter uebergeben werden.
 Die ueber SLOT verbundene Funktion erhaelt folgende Argumente:
 @_ = ($slot_object, @args);
 
 Da Signale nur in der objektorientieten Umgebung zum Einsatz kommen
 enthaelt wohl jede Unterroutine einen Code wie diesen:
 
 sub meine_slot_funktion {
    my ($self, $arg1, $arg2, ...) = @_;
 }
 
 Daher ist es notwendig $slot_object zu uebergeben.

=back

=head2 Anwendung

 Signale und Slots dienen dazu Objekte miteinander zu verbinden. Dazu
 ist es nicht notwendig Kenntnis vom Code der jeweiligen Objekte zu
 haben. Ein Beispiel:
 
 Eine Anwendung wird getrennt in Tk-Oberflaeche und Rechenprogramm.

=over Anwendung

=item Herkoemmlich

 use Tk;
 use GUI;
 use CALC qw(berechnung);
 
 my $mw = MainWindow->new();
 
 my $gui = GUI->new(-mainwindow => $mw);
 my $ok_bt = $gui->get_calc_button_widget();
 $ok_bt->configure(-command => sub { berechnung($gui->get_parameter()); });
 
 MainLoop;

=item oder mit Signalen und Slots

 package GUI;
 use Slots qw(SIGNAL PROVIDE EMIT);
 
 PROVIDE SIGNAL, 'CALC_BUTTON_PRESSED';
 ...
 $ok_bt->configure(-command => sub { $self->EMIT('CALC_BUTTON_PRESSED', @args) });
 
 
 package CALC;
 use Slots qw(SLOT PROVIDE);
 
 PROVIDE SLOT, 'BERECHNUNG', &berechnung;
 ...
 sub berechnung {
    my ($self, @parameter) = @_;
    ...
 }
 
 package main;
 
 use Tk;
 use GUI;
 use CALC;
 use Slots qw(CONNECT);
 
 my $mw = MainWindow->new();
 
 my $gui  = GUI->new(-mainwindow => $mw);
 my $calc = CALC->new();
 
 CONNECT $gui,  SIGNAL, 'CALC_BUTTON_PRESSED',
         $calc, SLOT,   'BERECHNUNG';
         
 MainLoop;

=back

 Der Vorteil bei der Verwendung von Signalen und Slots liegt darin,
 dass man eine definierte Schnittstelle zur Verfuegung stellen kann,
 ohne auf Interna der einzelne Module zuzugreifen. Eine Bescheibung
 der Schnittstelle kann wie folgt aussehen:
 
 package GUI:
 
 Folgende Signale werden ausgeloest:
 'CALC_BUTTON_PRESSED'                  Button 'Berechnung' gedrueckt
 'END_BUTTON_PRESSED'                   Button 'Beenden' gedrueckt
 
 
 package CALC:
 
 Folgende Slots sind definiert:
 'BERECHNUNG'                           verweist auf $obj->berechnung
 
 
 Eine neue Berechnungsmethode kann ohne weiteres getestet werden. Dazu
 muss das Hauptprogramm nur wenig veraendert werden.
 
  package main;
 
 use Tk;
 use GUI;
 use CALC;
 use Slots qw(CONNECT);
 
 my $mw = MainWindow->new();
 
 my $gui  = GUI->new(-mainwindow => $mw);
 my $calc = CALC->new();
 CONNECT $gui,  SIGNAL, 'CALC_BUTTON_PRESSED',
         $calc, SLOT,   'BERECHNUNG';
 
 # Ab hier Test fuer alternative Berechnung
 use CALC_ALTERNATIV;
 my $vari = CALC_ALTERNATIV->new();
 CONNECT $gui,  SIGNAL, 'CALC_BUTTON_PRESSED',
         $vari, SLOT,   'BERECHNUNG';
 # Test Ende
 
 MainLoop;

 Jetzt werden beide Berechnungen durchgefuehrt.