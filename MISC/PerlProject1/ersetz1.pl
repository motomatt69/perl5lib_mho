#!/usr/bin/perl -w
use strict;
$_ = "Er ist heute beim Kegeln mit Barney";
s/mit (\w+)/gegen $1's Mannschaft/;
print "$_\n";

print "________________________________\n";
$_ = "gruener schuppiger Dinosaurier";
s/(\w+) (\w+)/$2 $1/;
print "$_\n";

print "________________________________\n";
s/^/riesiger /;
print "$_\n";

print "________________________________\n";
s/sc.*gruener //;
print "$_\n";

print "________________________________\n";
s/\w+$/($`!) $&/;
print "$_\n";

print "________________________________\n";
s/ !/!/;
print "$_\n";

print "________________________________\n";
s/riesig/gigantisch/;
print "$_\n";

print "________________________________\n";
$_ = "Es grient so grien!";
s/grien/gruen/g;
print "$_\n";

print "________________________________\n";
$_ ="Ich sah Barney mit fred";
s/(fred|barney)/\U$1/gi;
print "$_\n";

print "________________________________\n";
s/(fred|barney)/\L$1/gi;
print "$_\n";

print "________________________________\n";
s/(\w+) mit (\w+)/\U$2\E mit $1/i;
print "$_\n";

print "________________________________\n";
s/(fred|barney)/\u\L$1/ig;
print "$_\n";