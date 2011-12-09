#!/usr/bin/perl -w
use strict;



my $z1 = 123;
my $z2 = 234;

my $z3 = $z1 & $z2;

my $z4 = $z1 | $z2;

my $z5 = $z1 ^ $z2;

my $z6 = ~$z1;

$z6 = $z6 & 255;

my $dummy;