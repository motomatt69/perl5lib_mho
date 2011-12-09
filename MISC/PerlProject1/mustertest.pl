#!/usr/bin/perl -w
use strict;
while (<>) {
    chomp;
    if (/Goethe/) {
        print "Treffer: |$`<$&>$'|\n";
        print "abgespeichert'1': $1\n";
        print "abgespeichert'2': $2\n";
    } else {
        print "Keine Treffer: |$_|\n";
    }
}

