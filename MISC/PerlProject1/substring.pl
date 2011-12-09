#!/usr/bin/perl -w
use strict;
my $Bspstring = "Dies ist ein Test";

my $wo=0;
until ($wo < 0) {
    $wo = index($Bspstring,"es",$wo+1);
print "$wo,";
}
