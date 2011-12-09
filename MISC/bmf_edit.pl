#!/usr/bin/perl -w
use strict;
use File::Slurp;

my $f = "c:\\dummy\\1\\148210_21107_0061_02.bmf_";
my $nf = "c:\\dummy\\1\\148211_21107_0061_02.bmf_";

my @l = File::Slurp::read_file($f, binmode => ':raw');

map{$_ =~ s/148210-/148211-/g;
    $_ =~ s/1(\d{3}-?\d{4})/2$1/g}@l;

File::Slurp::write_file($nf, {binmode => ':raw'}, @l);

print "fertig\n";
my $dummy;


