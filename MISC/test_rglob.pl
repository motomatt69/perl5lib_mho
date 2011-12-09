#!/usr/bin/perl -w
use strict;
use File::Spec;
use File::RGlob;
use File::Glob;

my $vol = '//server-daten/auftrag';
my @dirs = qw(Auftrag Auftrag_2009 090468_Alstom_RDK8 fuer_AV);
my $dir = File::Spec->catdir(@dirs);
#my $fn = '*';
my $fn;

my $path = File::Spec->catpath($vol, $dir, $fn);
$path = File::Spec->canonpath($path);
my @fs = glob($path . "/*");

my $glob =  File::RGlob->new();
$glob->path($path);
$glob->file_include(sub {0;} );
$glob->dir_include(sub { $_[0]->current_depth < 1 });
$glob->scan();
my $fs = $glob->get_directories();
my $dummy;