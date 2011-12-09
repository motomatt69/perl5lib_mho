#!/usr/bin/perl -w
use strict;
use PDL;

my $matrix = pdl [[5,3], [2,7], [8,10]];

$matrix += 20;
print $matrix;
my $dummy;


