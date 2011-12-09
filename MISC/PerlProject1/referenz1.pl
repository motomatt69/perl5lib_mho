#!/usr/bin/perl -w
use strict;

my $str = "Dies ist ein string";
my $strref=\$str;
print $strref,"\n";
my @array=(1..10);
my $arrayref=\@array;
print $arrayref;