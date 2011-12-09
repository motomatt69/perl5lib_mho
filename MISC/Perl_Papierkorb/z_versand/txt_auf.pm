#!/usr/bin/perl -w
package z_versand::txt_auf;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw (txt_auf_akt);

use strict;
use Tk;
use z_versand::archiv_db qw(aufdat $aufakttxtref zngzaehl);

#Auftragsdaten aktualisieren
sub txt_auf_akt {
    my ($aufakt, $txt_auf, $zngdatref) = @_;
    $aufakt=$1 if ($aufakt=~ m/(\d+);\d/); #Auftragsnummer von ListboxIndex trennen
    #Auftragsdaten holen
    my $aufakttxtref= &aufdat($aufakt);
    #Anzahl Zeichnungen holen
    my $counthashref = &zngzaehl($zngdatref);
    my $zngzaehltxt = "$$counthashref{zng} Teilsysteme; $$counthashref{blt} Blätter (davon $$counthashref{ind} mit Index)";
    #Auftragstextbox füllen
    $txt_auf->delete("1.0",'end');#Erstmal alles löschen
    $txt_auf->insert('end', "Auftrag: $$aufakttxtref{Auftrag}\n",[],
                            "Bauwerk: $$aufakttxtref{Bauwerk}\n",[],
                            "Bauherr: $$aufakttxtref{Bauherr}\n",[],
                            "Architekt: $$aufakttxtref{Architekt}\n",[],
                            "Projektleiter: $$aufakttxtref{Projektleiter}\n",[],
                            "$zngzaehltxt\n",[]);
}


1;