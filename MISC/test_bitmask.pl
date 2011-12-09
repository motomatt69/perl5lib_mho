#!/usr/bin/perl -w
use strict;
use Bit::Bitmask;



my @bits = (qw(state1 state2 state3 state4 state5 state6));

my $bitm = Bit::Bitmask->new();
$bitm->defineBits(@bits);

my $state = 'FF';

$bitm->readValue($state);

my %states = map {$_ => $bitm->chkBit($_)} @bits;
map {print $_ ,"state = ",$states{$_},"\n"} sort keys %states;

#$bitm->delBit('state1');

#my $str = $bitm->writeValue;
#print "$str\n";
my $dummy;



