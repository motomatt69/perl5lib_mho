#!/usr/bin/perl -w
use strict;

my ($satz,$key);
print "Satz eingeben\n";
chomp ($satz=<STDIN>);
print "zeichen eingeben\n";
chomp ($key=<STDIN>);
my @zeichen=();
@zeichen=split //,$satz;
my $anzahl=0;
$anzahl = grep {$_ eq $key} @zeichen;
print $anzahl;