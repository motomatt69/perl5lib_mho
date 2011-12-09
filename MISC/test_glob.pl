#!/usr/bin/perl -w
use strict;
use File::Spec;

my $p1 = '\\\\server-daten\AUFTRAG\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*.*';
my $p ='\\\\server-daten\auftrag\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*.*';
my $p3 ='T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*\?????_????_??.pdf';
my $p4 ='T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*\*\?????_????_??.pdf';
my $p2 = 'c:\dummy\*.*';

 my @dirs = qw(T: Auftrag Auftrag_2009
                   090468_Alstom_RDK8 cards druckdateien_neu);
    
  
    
    my $dir = File::Spec->catdir(@dirs);
    my $f = '*.*';
    my $path = File::Spec->catfile(@dirs, $f);
    
    my @files = glob ($path);
#my @files = glob ($p4);

my $dummy;


