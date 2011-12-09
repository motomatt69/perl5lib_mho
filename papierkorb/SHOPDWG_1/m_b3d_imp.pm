package PPEEMS::SHOPDWG_1::m_b3d_imp;

use strict;
use MHO_DB::TABS;
use File::RGlob;
use File::Slurp;

use Moose;

has 'members_ascii'   => (isa => 'HashRef', is => 'ro', required => 0);
has 'result'    => (isa => 'Str',      is => 'ro', required => 0);
has 'manylist'  => (isa => 'ArrayRef', is => 'ro', required => 0);

sub import_list{
    my ($self) = @_;
    
    my $linesref = $self->_ascii_einlesen('struktur');
    if (!$linesref){
        $self->{result} = "Abbruch; Strukturliste und Bauteilliste
                            haben unterschiedlichen Stand\n";
        return 0
    }
    my @lines = @$linesref;
    
    my $anzls = @lines;
    print "Struktur, Anzahl vor Bereinigung: $anzls\n";
    @lines = grep {$_ =~ m/\d{6}\d*\|     #mindestens6stellige IdentNr
                   \d{6}\|                #6-stellige TS Nummer
                   \d{5}\d*\|             #mindestens 5-stellige PosNr
                   \S*\|                  #irgendeine Bezeichnung    
                   \d{6}\d*\|             #mindestens 6-stellige LeitteilIndentnr
                   /x} @lines;
    
    
    $anzls = @lines;
    print "Struktur, Anzahl nach Bereinigung: $anzls\n";
    
    map {$_ =~ s/\|/;/g} @lines;
    my @strukts = map {[split ';', $_]} @lines;
    
    # Anzahl ermitteln und in @strukts schreiben
    my %anz;
    map{$anz{$_->[1].'_'.$_->[2]}++} @strukts; 
    map{$_->[5] = $anz{$_->[1].'_'.$_->[2]}} @strukts;
            
    #check doppelte Alstomeinträge;
    my @apbposs = grep {$_->[3] =~ m/\d{4}-\d{4}/} @strukts;
    my %double; 
    for my $p (@apbposs){
        my $apbpos = $p->[3];
        $double{$apbpos} += 1;
    }
    my @apbs = grep {$double{$_} > 1} keys %double;
    my @manylist;
    for my $apb (@apbs){
        my @b3ds = grep {$_->[3] eq $apb} @apbposs;
        for my $b3d (@b3ds){
            push @manylist, 'TS: '.$b3d->[1].' Pos: '.$b3d->[2].' Alstom_id: '.$b3d->[3].' Idend: '.$b3d->[0].' LeitIdend: '.$b3d->[4]
        }
    }
    #if (@manylist){
    #    $self->{result} = "Doppelte Alstom Positionen vorhanden\n";
    #    $self->{manylist} = \@manylist;
    #    return 0
    #}
    
    #check Einzelausschreibung
    for my $key (keys %anz){
        my ($ts, $pos) = $key =~ m/^(\d{6})_(\d+)/;
        my @singleposs = grep {$_->[1] == $ts && $_->[2] == $pos} @strukts;
        if ($anz{$key} == $#singleposs){
            $self->{result} = "Liste nicht mit Einzelauflistung aus b3D ausgeschrieben\n";
            return 0
        }
    }
    
    #bauteilliste einarbeiten
    @lines = @{$self->_ascii_einlesen('bauteile')};
    $anzls = @lines;
    print "Bauteile, Anzahl vor Bereinigung: $anzls\n";
    @lines = grep {$_ =~ m/\d{6}\d*\|     #mindestens6stellige IdentNr
                   \S*\|                  #Irgendeine Profilbezeichnung
                   \S\S*\|                #S und irgendeine Materialbezeichnung
                   \d{4}\d*\|             #Mindestens 4stellige Laenge   
                   \d+\.\d{3}\|           #Gewicht mit 3 Kommastellen
                   \d+\.\d{3}\|           #Oberfläche mit 3 Kommastellen
                   /x} @lines;
    
    
    $anzls = @lines;
    print "Bauteile, Anzahl nach Bereinigung: $anzls\n";
    
    map {$_ =~ s/\|/;/g} @lines;
    my @bts = map {[split ';', $_]} @lines;
    
    my %members_ascii;
    for my $str (@strukts){
        my ($bt) = grep{$_->[0] == $str->[0]} @bts;
        my %member = ('ident'       => $str->[0],
                      'ts'          => $str->[1],
                      'pos'         => $str->[2],
                      'kenn'        => $str->[3],
                      'ltindent'    => $str->[4],
                      'tsqt'        => $str->[5],
                      'profil'      => $bt->[1],
                      'mat'         => $bt->[2],
                      'laenge'      => $bt->[3],
                      'gew'         => $bt->[4],
                      'surface'     => $bt->[5]);
        
        $members_ascii{$str->[0]} = \%member; 
    }
    
    $self->{members_ascii} = \%members_ascii;
    $self->{result} = "Listenimport ok";
    return 1
}


sub _ascii_einlesen{
    my ($self, $list) = @_;
    
    my $vol = '//server-bocad/AUFTRAEGE/';
    my @dirs = ($vol,
                '090477_eemshaven_original',
                'lists');
    
    my $p = File::Spec->catdir(@dirs);
    
    my $glob =  File::RGlob->new();
    $glob->file_include(sub {$_[1] =~ m/^struktur_list_\d{2}\.lis/});
    $glob->path($p);
    $glob->scan();        
    my @fs = @{$glob->get_files()};
    my @sortfs = sort {$a cmp $b} @fs;
     
    my %file;
    $file{struktur} = pop @sortfs;
    $file{bauteile} = $file{struktur};
    $file{bauteile} =~ s/struktur/bauteile/;
    
    if (!-e $file{bauteile}) {
        return;
    }
     
    my @lines = File::Slurp::read_file($file{$list});
    
    map {$_ =~ s/\s*//g} @lines;
    map {$_ =~ s/^\|//} @lines;
    
    return \@lines;
}
1;