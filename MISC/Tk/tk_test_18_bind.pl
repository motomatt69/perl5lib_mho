#!/usr/bin/perl -w
use strict;

use Tk;
my $eingabe = "Passwortabfrage";

my $mw = MainWindow -> new;

my $frm1=$mw->Frame->pack(-side=>'top');
my $frm2=$mw->Frame(-relief => 'sunken',
                    -borderwidth=>1)->pack(-side=>'top');

my $frm3=$mw->Frame->pack(-side=>'top');
my $frm4=$mw->Frame(-relief => 'groove',
                    -borderwidth=>1)->pack(-side=>'top');

my $lbltxt = $frm1->Label(-text=>'Passwort eingeben (Pinguine): ')->pack();
my $inp = $frm2->Entry()->pack();
my $lblout = $frm3->Label(-textvariable=>\$eingabe)->pack();

$inp -> bind('<Return>', sub {input()}); #reagiert auf die Taste Enter

MainLoop;
#Überprüfung Passwort

sub input {
    if ($inp->get() eq "Pinguine"){
        $eingabe = "Passwort richtig";
        $inp->delete(0,100);
        my$btoschalter=$frm4->Button(-text=>'Weiter',
                                     -command => sub {exit 0}) ->pack();
    }else{
        $eingabe = "Passwort falsch";
        $inp->delete(0,100)
    }
}

                           
                           