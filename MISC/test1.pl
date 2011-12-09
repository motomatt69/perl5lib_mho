#!/usr/bin/perl -w
use strict;

use Date::Calc qw(Today Add_Delta_Days);

my ($y, $m, $d) = Today();

my $days = 30;
($y, $m, $d) = Add_Delta_Days($y, $m, $d, $days);

my $wert = 12354;
my $gerundet = sprintf "%d", $wert;
my $dummy;


