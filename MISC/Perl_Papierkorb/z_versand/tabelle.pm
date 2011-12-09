package z_versand::tabelle;
use z_versand::archiv_db qw(zngzaehl);
use strict;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(tab_ins $tm tab_fill);

sub tab_ins {
    my ($zngdatref, $fm)=@_;
    #Zeichnungsdaten holen
    #$aufakt=$1 if ($aufakt=~ m/(\d+);\d/); #Auftragsnummer von ListboxIndex trennen
    #my $zngdatref = &zngabfrag($aufakt); 
    # Einträge zählen
    my $counthashref = &zngzaehl($zngdatref);
    my $countblt=$$counthashref{blt};
    #Tabelle erstellen
    my $tm=$fm->Scrolled("TableMatrix", -rows=>$countblt+1,#Anzahl Blätter + Kopfzeile
                                        -cols=>20,
                                        -resizeborders=>'both',
                                        -titlerows=>1,
                                        -cache=>1,
                                        -scrollbars=>"e",);
  
}

sub tab_fill {
    my ($aufakt, $tm)=@_;
    $tm->set("0,0","alias");
    $tm->set("0,1","bmf_");
    $tm->set("0,2","plt");
    $tm->set("0,3","dxf");
    $tm->set("0,4","pdf");
    $tm->set("0,5","Dateiname");
    $tm->set("0,6","Rev");
    $tm->set("0,7","Benennung");
}

1;