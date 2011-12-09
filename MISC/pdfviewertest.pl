#!/usr/bin/perl -w
use strict;

my $pdf = 'C:/dummy/148190_21205_7602_56.pdf';

if (-e $pdf){
    my $pdfxchange = $ENV{PDFXCHANGE};
    system "$pdf";
}