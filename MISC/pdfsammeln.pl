#!/usr/bin/perl -w
use strict;

my $pdf_cmd = $ENV{PDFTK};
    
    
system $pdf_cmd, 'c:\dummy\qwspdfs\*.pdf', 'output', 'c:\dummy\qwspdfs\qwskatalog.pdf';
    


