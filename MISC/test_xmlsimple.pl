#!/usr/bin/perl -w
use strict;

use XML::Simple;
#use XML::Parser;

my $hashref = {test1 => 'gut',
               test2 => 'bad'};

my $xml = XMLout($hashref);



#my $xml = XMLin(q~//server-bocad3d/auftrag/weldtimes/11027710003RAHMEN ACHSE i',g'10.11.2011.xml~);





my $dummy;