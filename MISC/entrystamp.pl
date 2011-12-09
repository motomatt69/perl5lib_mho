#!/usr/bin/perl -w
use strict;
use File::Spec;
use PDF::API2;
#use constant mm => 25.4 / 72;

my @dirs = qw(c: dummy);
my $dir = File::Spec->catdir(@dirs);

my $in_f = glob ($dir.'\wordtest.pdf');

my $pdf = PDF::API2->open($in_f);
my $page = $pdf->openpage(1);
my @sizes = $page->get_mediabox;

my $inspx = $sizes[2] - 100;
my $inspy = 100;

my $font = $pdf->corefont('Helvetica-Bold');

my $text = $page->gfx();
$text->font($font, 36);
$text->textlabel($inspx, $inspy,
                 $font, 10,
                 "090468 ALSTOM RDK8",
                -align => 'left',
                -fillcolor => ("FF0000")
                );
$text -> stroke();
#$text->fillcolor("FF0000");
#$text->text_center('test');
#$text->transform(-translate => [50, 50]);



#$pdf->update();
my $sp = File::Spec->catfile(@dirs, 'test.pdf');
$pdf->saveas($sp);
$pdf->end;


my $dummy;


