#!/usr/bin/perl -w
use strict;

use CAM::PDF;

my $pdf = CAM::PDF->new('c:\\dummy\\212P20200_00.pdf');

$pdf->getPrefs();
#my @content = $pdf->Content();

my $version = $pdf->{pdfversion};
my $dummy;


