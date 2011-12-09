#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;

use z_versand::aufsav qw(auf_read $aufakt);
use z_versand::archiv_db qw(zngabfrag $zngdatref);
use z_versand::txt_auf qw(txt_auf_akt);
use z_versand::tabelle qw(tab_ins tab_fill);

#Aktuellen Auftrag einlesen;
my $aufakt = auf_read; #Auftragsnummer mit Listboxindex
#Zeichnungsdaten holen
my $zngdatref = &zngabfrag($aufakt); 

#Hauptfenstereinteilung, Framesanordnung
my $mw = MainWindow->new;
my $fo = $mw->Frame(); my $fm = $mw->Frame(); my $fu = $mw->Frame();
$fo->grid(-row=>0,-column=>0);$fm->grid(-row=>1,-column=>0);$fu->grid(-row=>2,-column=>0);
#Zeugs definieren
#Auftrag auswählen
my $bto_aufausw=$fo->Button(-text=>'Auftrag', 
                            -command=>sub {bto_aufausw()});

#Auftragsdatenfenster anzeigen
my $txt_auf=$fo->Text(-height=>6,
                      -width=>60);
#Aufhören
my $bto_exit =$fo->Button (-text=>"exit",
                           -command=> sub {exit(0)});
#Tabelle anzeigen
my $tm= tab_ins($zngdatref, $fm);

#Zeugs anordnen
$bto_aufausw->grid(-row=>0,-column=>0);
$txt_auf->grid(-row=>0,-column=>1);
$bto_exit->grid(-row=>0,-column=>2);
$tm->grid(-row=>1,-column=>0);

#Tabelle füllen
&tab_fill ($aufakt, $tm);

#Auftragstextbox füllen
&txt_auf_akt ($aufakt, $txt_auf, $zngdatref);
MainLoop;

sub bto_aufausw {
    use z_versand::aufausw qw(auftrag_auswahl);
    auftrag_auswahl ($mw,  $txt_auf, $aufakt);#
}

