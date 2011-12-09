#!/usr/bin/perl -w
use strict;

use PDF::API2;

my $pdf = PDF::API2->new(-file => 'c:\dummy\test3.pdf');

my $page = $pdf->page;
my $txt = $page->text;
my $gfx = $page->gfx;

my $HelveticaBold = $pdf->corefont('Helvetica-Bold');

my $x = 100;
my $y = 200;

$txt->font($HelveticaBold, 14);
$txt->translate($x,$y);
$txt->text_center("Helvetica Bold, Grösse 14");
$txt->stroke();

$x = 200;
$y = 400;
$txt->translate($x,$y);
$txt->text_center("Neuer Text");

$gfx->strokecolor("#FF0000");
$gfx->move(20,180);
$gfx->line(180,180);
$gfx->stroke();
#$gfx->endpath();
$gfx->move(20,100);
$gfx->line(180,100);
$gfx->stroke();

$pdf->finishobjects($page, $gfx, $txt);
$pdf->save;
$pdf->end();