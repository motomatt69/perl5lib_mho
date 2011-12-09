#!/usr/bin/perl -w
package z_versand::aufausw;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw (auftrag_auswahl);

use strict;
use Tk;

sub auftrag_auswahl {
    use z_versand::aufsav qw(auf_write);
    use z_versand::archiv_db qw(aufabfrag $auftraegeref zngabfrag);
    use z_versand::txt_auf qw(txt_auf_akt);
    
    my ($mw, $txt_auf, $aufakt) = @_; 
#Auftragsliste aus DB holen
    my $auftraegeref=&aufabfrag();
    
    my $popup=$mw->Toplevel;
#Listbox mit scrollbar erstellen   
    #my $yscroll=$popup->Scrollbar();
    #my $lbx=$popup->Listbox(-yscrollcommand=>['set'=>$yscroll],
    #                        -height=>50,
    #                        -selectmode=>'single');
    #$yscroll->configure(-command=>['yview',$lbx]);
    #$yscroll->set(0.5,0.8);
    #$yscroll->pack(-side=>'right', -fill=>'y');
    #$lbx->pack;
    my $lbx = $popup->Scrolled('Listbox',
                        -height=>32,
                        -scrollbars=>'e',
                        -selectmode=>'single')->pack;
    $lbx->insert('end',@$auftraegeref);
#Selection auf letzten Auftrag setzen    
    my $lbxIndex=$2 if ($aufakt =~ m/(\d+);(\d+)/);
    $lbx->selectionSet ($lbxIndex);
#Gewählten Auftrag auslesen und abspeichern        
    $lbx->bind('<Button-1>',
           sub {my @sel=$lbx->curselection();
                $aufakt=$$auftraegeref[$sel[0]].";".$sel[0];#Auftrag und ListboxIndex 
                auf_write ($aufakt); #gewählter Auftrag abspeichern
                });
#Listbox wieder abschalten, Auftragsdaten aktualisieren
    my $bto_Ok=$popup->Button(-text=>'ok',
                                -command=> sub {                        
                                                #Zeichnungsdaten holen
                                                $aufakt=$1 if ($aufakt=~ m/(\d+);\d/); #Auftragsnummer von ListboxIndex trennen
                                                my $zngdatref = &zngabfrag($aufakt); 
                                                &txt_auf_akt($aufakt, $txt_auf, $zngdatref);
                                                $popup->destroy if Tk::Exists($popup)
                                            })->pack;

}


1;