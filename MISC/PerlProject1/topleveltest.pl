#!/usr/bin/perl -w
use strict;
use Tk;

my $mw = MainWindow->new;

my $bto1 =$mw->Button (-text=>"toplevel",
                       -command=> sub {toplevel()})->pack;
my $bto2 =$mw->Button (-text=>"exit",
                       -command=> sub {exit(0)})->pack;

MainLoop;
my $popup;my $inp;

sub toplevel {
$popup = $mw->Toplevel();
$inp = $popup->Entry()->pack;
my $bto3 = $popup->Button (-text=>"exit",
                           -command => sub {bto3()})->pack;
}

sub bto3 {
print $inp->get();
$popup->withdraw    
}
    