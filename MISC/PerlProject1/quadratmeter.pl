#!/usr/bin/perl -w
use strict;


print "Bitte die Breite eingeben: ";
chomp (my$breite=<STDIN>);
print "Bitte die Laenge eingeben: ";
chomp (my$laenge=<STDIN>);
my$qm = $breite * $laenge;
print "Der Raum hat $qm m2.\n";


