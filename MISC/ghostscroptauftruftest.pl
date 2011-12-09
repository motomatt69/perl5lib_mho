#!/usr/bin/perl -w
use strict;

my @gsargs;

push @gsargs, qw{-q -dNOPAUSE -dBATCH};
push @gsargs, '-sDEVICE=pdfwrite';
push @gsargs, '-dCompatibilityLevel=1.3';

my $tmpfile = 'c:\dummy\418P10002_00neu.pdf';
my $psfile = 'c:\dummy\418P10002_00.pdf';

push @gsargs, "-sOutputFile=$tmpfile";
push @gsargs, '-f', $psfile;

my $gs = $ENV{'GS'};
system ($gs, @gsargs);

my $dummy;


