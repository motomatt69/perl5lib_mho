#!/usr/bin/perl -w
use strict;
use File::Copy;
use File::Spec;

my $rootdir = '//server-daten/auftrag/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/Zeichnungen/pdf/21503';

my $rfile = '148190_21503_0268_00.pdf';
my $zfile = '21503_0268_00.pdf';

my $rootpath = File::Spec->catdir($rootdir);
my $rootfile = File::Spec->catfile($rootpath,$rfile);

my $savedir = '//server-daten/auftrag/Auftrag/Auftrag_2009/090468_Alstom_RDK8/fuer_AV/21503_0268';

my $savefile = File::Spec->catfile( $savedir, $zfile);

copy($rootfile,$savefile) or die "Copy failed: $!";

print "ok";
my $dummy;