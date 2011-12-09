#!/usr/bin/perl -w

use strict;
my $count=0;
while (<>) {
    chomp;
    if (/se+/) {
        print "Treffer: |$`<<$&>>$'|\n";
        #print "abgespeichert'1': $1\n";
        #print "abgespeichert'2': $2\n";
    } else {
        print "Keine Treffer: |$_|\n";
    }
    while (/se+/) {
        $count++
    }
    print "____$count x gefunden____\n";
}




