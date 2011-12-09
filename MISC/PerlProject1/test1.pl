#!/usr/bin/perl -w
use strict;

my %test = (eins => 1, zwei => 2, 'drei', 3 , vier => 4);
#my $anz = @{%test} / 2;
my $an2 = keys %test;
print " $an2 \n";