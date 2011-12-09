#!/usr/bin/perl -w
use strict;

my @znrs = qw(21409-0125-02 21409-0125-10 21409-0125-05 21409-0125-00 21409-0125-29 21409-0125-19);

my @sortiert = sort {$a cmp $b} @znrs;

my $val = $sortiert[-1];
my $dummy