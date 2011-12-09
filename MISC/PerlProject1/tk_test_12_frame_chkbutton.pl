#!/usr/bin/perl -w
use strict;

use Tk;

my $mw = MainWindow->new;

my $frm_left=$mw->Frame()->pack(-side => 'left');
my $frm_right=$mw->Frame()->pack(-side => 'right');


my $ckbu1 = $frm_left->Checkbutton(-text => 'Kontrollkästchen 1')->pack(); #Kontrollfeld 
my $ckbu2 = $frm_left->Checkbutton(-text => 'Kontrollkästchen 2')->pack();

my $rdobu1 = $frm_right->Radiobutton(-text => 'Optionsfeld1')->pack(); #Optionsfeld
my $rdobu2 = $frm_right->Radiobutton(-text => 'Optionsfeld2')->pack();

my $liste = $mw->Listbox(-relief => 'sunken', #Liste mit Einträgen zur Auswahl  
                         -width => -1,
                         -height => 5,
                         -setgrid => 1);

my @elemente = qw(Teil1 Teil2 Teil3 Teil4);
foreach (@elemente) {
    $liste->insert('end', $_);
}
$liste->pack();

MainLoop;
