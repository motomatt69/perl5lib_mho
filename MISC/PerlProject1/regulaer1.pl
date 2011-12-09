#!/usr/bin/perl -w
use strict;
my@text = ("fred", "alfred", "Fred Heinz Barney", "Heinz", "Mr.Schiefer", "Barney Heinz Fred");
my($text,$i);
foreach $text (@text) {
    $i++;
    if ($text =~ /\b[Ff]red/) {
        print "$i: $text passt\n";
    } else {
        print "$i: $text passt nicht\n";
    }
}

