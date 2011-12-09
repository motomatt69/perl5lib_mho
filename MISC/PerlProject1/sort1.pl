#!/usr/bin/perl -w
use strict;
my @numbers = (17,1000,04,1.5,3.1459,-10,1.5,4,2001,90210,666);
my @sortiert = sort {$a <=> $b} @numbers; #numerisches Sortieren mit dem Raumschiffoperator
foreach (@sortiert) {
    printf "%10g|",$_ ;
}
print "\n";
#rueckwaerts sortieren
@sortiert = ();
@sortiert = reverse sort {$a <=> $b} @numbers; #numerisches Sortieren mit dem Raumschiffoperator
foreach (@sortiert) {
    printf "%10g|",$_ ;
}
