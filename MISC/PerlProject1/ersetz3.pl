#!/usr/bin/perl -w
use strict;
my$was = "fred|barney";
while (<>) {
    
if (/($was){3}/) {
    print "Treffer: $&";
} else {
    print "kein Treffer";
}
}


