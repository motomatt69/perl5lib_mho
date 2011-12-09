#!/usr/bin/perl -w
use strict;
foreach (1..10) {
    my($quadrat)=$_ * $_;
    print "$_ zum Quadrat = $quadrat\n";
}



print"_____________________________\n";
my@namen=qw(Fred Barney Betty Dino Wilma Pebbles Bam.Bam);
my$ergebnis= welches_element_ist("Dino",@namen)+1;
print $ergebnis;

sub welches_element_ist {
    my($was,@array) = @_;
    foreach (0..$#array) {
        if($was eq $array[$_]) {
            return $_;
        }
    }
    -1;
}
