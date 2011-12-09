#!/usr/bin/perl -w
use strict;
print "Einige Zeilen eingeben: \n";
chomp (my@zeilen=<STDIN>);

printf "1234567890" x 7;
foreach(@zeilen) {
    printf "%20s\n",$_;
}

