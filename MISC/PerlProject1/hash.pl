#!/usr/bin/perl -w
#use strict;
%paare = ('rot'=>255,'grün'=>150,'blau'=>0);
foreach $paare (sort keys %paare) {
    print "$paare\n";
}


