#!/usr/bin/perl -w
use strict;
#my @fred =qw{1 3 5 7 9};
my $fred_gesamt = &gesamt(1..10000000);
print "Die Summe von \@fred ist $fred_gesamt.\n";

sub gesamt{
    my($summe);
    foreach (@_){
        $summe += $_;
    }
    $summe;
}

