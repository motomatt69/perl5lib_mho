#!/usr/bin/perl -w
use strict;
my $pattern = "aus";
my $count = 0;

while (<>) {
    chomp;
    while (/$pattern/g) {
        print "Treffer: |$`<<$&>>$'|\n";
        $count++;
        #print "abgespeichert'1': $1\n";
        #print "abgespeichert'2': $2\n";
    } 
}
print "$pattern kommt $count mal vor:\n";
