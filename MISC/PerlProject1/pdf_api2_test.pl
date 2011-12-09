#!/usr/bin/perl -w
use strict;

use PDF::API2;

my $pdf = PDF::API2->new();

my $page = $pdf->page;

#$page->mediabox(200,200);
my $gfx = $page->gfx;
$gfx->strokecolor("#FF0000");
$gfx->move(0,0);
$gfx->line(100,100);
$gfx->stroke();
$gfx->endpath();

$gfx->strokecolor("#00FF00");
$gfx->move(150,150);
$gfx->line(150,50);
$gfx->stroke();
$gfx->endpath();

$pdf->saveas("c:\\dummy\\test1.pdf");
