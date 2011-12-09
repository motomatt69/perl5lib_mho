#!/usr/bin/perl -w
use strict;
use Bestiary qw(camel $weight2);

my $weight1 = 24;
print "$weight1\n";
#camel($weight1);

my $weight2 = camel($weight1);
print  "$weight2 im Hauptprogramm\n";

