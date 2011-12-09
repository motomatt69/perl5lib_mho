#!/usr/bin/perl -w
use strict;
my$fahr = 0;
my$cel = 0;

print "Geben Sie eine Temperatureínheit in Fahreinheit ein: ";
chomp ($fahr=<stdin>);
$cel = ($fahr - 32) * 5 / 9;
print "$fahr entsprechen ";
printf ("%d Grad Celsius\n", $cel);

