#!/usr/bin/perl -w
use strict;

my @zahlen = (1..4,13,25);
my @quad = &quadro(@zahlen);
foreach $_ (@quad){
    print "$_\n";
}

sub quadro {
    my @quad;
    foreach $_ (@_) {
        $quad[$_]=$_ * $_
    }
    return @quad
}
