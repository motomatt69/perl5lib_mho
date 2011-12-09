#!/usr/bin/perl -w
use strict;
my(@woerter, %zaehler, $wort);
print "Woerter eingeben:\n";
chomp(@woerter=<STDIN>);

foreach $wort (@woerter) {
    $zaehler{$wort} ++;
}

foreach $wort (sort keys %zaehler) {
   print "$wort kam $zaehler{$wort} vor.\n"; 
}

