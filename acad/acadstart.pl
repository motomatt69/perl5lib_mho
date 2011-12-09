#!/usr/bin/perl -w
use strict;

#my $vorh_dwg = system ("c:\\programme\\autocad 2005\\acad.exe", "c:\\dummy\\lisp\\a.dwg");#vorhandene Zeichnung öffnen
#my $neu_dwg = system ("c:\\programme\\autocad 2005\\acad.exe", '/t',"bsize.dwt");#neue Zeichnung auf template basis
my $vorh_dwg = system ("c:\\programme\\autocad 2005\\acad.exe", "c:\\dummy\\lisp\\c.dwg",'/b', "c:\\dummy\\lisp\\start.scr" );#vorhandene Zeichnung öffnen und script ausführen
#weitere Schalter: http://www.augi.com/publications/hotnews.asp?page=439
print "Ende: $vorh_dwg\n";


