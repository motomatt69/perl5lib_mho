#!/usr/bin/perl -w
use strict;

my $vorh_dwg = system ("c:\\programme\\autocad 2005\\acad.exe", "c:\\lisp\\a.dwg");#vorhandene Zeichnung �ffnen
#my $neu_dwg = system ("c:\\programme\\autocad 2005\\acad.exe", '/t',"bsize.dwt");#neue Zeichnung auf template basis
# my $dwg = system ("c:\\programme\\autocad 2005\\acad.exe", "c:\\lisp\\a.dwg",/b, "c:\\lisp\\scridt1.lsp" );#vorhandene Zeichnung �ffnen und script ausf�hren
#weitere Schalter: http://www.augi.com/publications/hotnews.asp?page=439
print "Ende: $vorh_dwg\n";


