#!/usr/bin/perl -w
use strict;
my$zufall = int(1 + rand 100);
print "Zahlen eingeben:\n";
while (<>) {
    chomp;
if ($_=~ /quit|exit|^\s*$/i) {
    print "und Tschuess\n";
    last;
    } elsif ($_>$zufall) {
        print "Zahl zu hoch\n";
    } elsif ($_ < $zufall) {
        print "Zahl zu niedrig\n
        ";
    } else {
        print "Treffer";
        last;
    }
}
