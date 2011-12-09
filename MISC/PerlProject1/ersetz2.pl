#!/usr/bin/perl -w
use strict;
$_="abc:def:::g:h";
my@felder = split/:/,$_;

foreach $_ (@felder) {
    print "$_|";
}
print"\n";

my$x = join ":" , @felder;
print "$x\n";

$x = join "_" , @felder;
print "$x\n";

$x = join "" , @felder;
print "$x\n";

