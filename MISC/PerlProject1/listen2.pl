#!/usr/bin/perl -w
use strict;
my @liste1=(1..10);
my @liste2;
foreach $_ (@liste1) {
    if ($_<5) {
        push @liste2,$_
    }
}
print @liste1,"\n";
print @liste2,"\n";
    

