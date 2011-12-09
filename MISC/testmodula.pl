#!/usr/bin/perl -w
use strict;

my $cube = 185;
my $r = $cube % 10;

$cube = $cube - ($cube % 10) if ($cube % 10);


my $dummy;
