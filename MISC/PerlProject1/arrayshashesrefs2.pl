#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;



my $hashref={};
my $mw = MainWindow->new;
my $tm = $mw->TableMatrix(-cols => 2,
                          -rows => 10,
                          -variable => $hashref,);




foreach my$i (0..10) {
    foreach my$j (0..1) {
     $hashref->{"$i,$j"}="$i te zeile, $j te spalte";
    }
}

$tm->colWidth (0 => -150, 1 => -150);

$tm->grid(-row => 0, -column => 0); 
Tk::MainLoop;  
1;