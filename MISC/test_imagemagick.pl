#!/usr/bin/perl -w
use strict;

my $ps = "C:\\dummy\\hwspdfs\\bltr.ps";
my $pdf = "C:\\dummy\\hwspdfs\\bltr.pdf";
my $gs = $ENV{GS};
my @opts = ('-q', '-dNOPAUSE' ,'-dBatch' ,'-sDEVICE=pdfwrite', "-sOutputFile=$pdf");

system $gs, @opts, $ps;#, '-dBATCH', '-dNOPAUSE', 'c:\dummy\hwspdfs\bltr.ps';


my $dummy;
