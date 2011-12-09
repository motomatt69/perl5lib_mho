#!/usr/bin/perl -w
use strict;
while(<>) {
    chomp;
    if (/\s+$/) {
        print "Treffer: $&#\n"; 
    } else {
        print "kein Treffer";
    }
}


