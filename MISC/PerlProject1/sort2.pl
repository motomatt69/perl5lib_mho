#!/usr/bin/perl -w
use strict;
my %nachname= qw {fred feuerstein Wilma Feuerstein Barney Geroellheimer betty geroellheimer Bam-Bam Geroellheimer PEBBLES FEUERSTEIN};
my @reihenfolge = sort {"\L$nachname{$a}" cmp "\L$nachname{$b}" or "\L$a" cmp "$b" } keys %nachname ;

 foreach (@reihenfolge) {
 print "$nachname{$_}, $_\n";
 }