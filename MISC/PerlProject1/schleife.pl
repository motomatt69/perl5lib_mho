#!/usr/bin/perl -w
use strict;
my $i = 0;

while ($i < 100) {
    $i += 5;
    print "wert: $i \n";
    $i++;
    print "wert: $i \n";
    $i--;
    print "wert: $i \n";
    print "check \n"
}

$i=1;
while ($i < 100) {
    print 10 x $i ." \n";
    $i++;
}