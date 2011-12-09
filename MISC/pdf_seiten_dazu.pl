#!/usr/bin/perl -w
use strict;
use PDF::API2;
use File::Spec;

my $pdf = PDF::API2->new();

#my $vorlage = PDF::API2->open('//server-daten/AUFTRAG/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/vorlagen/bundle_vorlage.pdf');

#my $page = $pdf->importpage($vorlage, 1);

#my $pagenew = $pdf->page;
#my  $pagenew=$pdf->importpage($vorlage, 2);
my $page = $pdf->page();

my @dirs = qw(c: dummy);
my $imgfile = 'swd_entry_logo.jpg';
my $imgpath = File::Spec->catfile(@dirs, $imgfile);

my $img = $pdf->image_jpeg($imgpath);
my $gfx = $page->gfx();
$gfx->rect(100,100,200,350);
$gfx->clip;
$gfx->stroke();

$gfx->image($img, 0, 0, 1);




my $f = 'testpdf.pdf';

my $pfad = File::Spec->catfile(@dirs, $f); 
$pdf->saveas($pfad);
    

$pdf->end();