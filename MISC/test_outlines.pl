#!/usr/bin/perl -w
use strict;

use PDF::API2;
use Time::localtime;

my $pdf = PDF::API2->new();
my $otls = $pdf->outlines();
my $font = $pdf->corefont('Helvetica');

for my $j (1..5) {
    
    my $sct = $otls->outline();
    $sct->title("section $j");
    
    
    for my $i (1..10){
        my $page = $pdf->page();
        $page->mediabox('A4');
        my $text = $page->text();
        $text->translate(200,300);
        $text->font($font, 36);
        $text->text("section $j page $i");
        
        my $gfx = $page->gfx();
        my $rectxy = $gfx->rectxy(100,100,200,200);
        $gfx->stroke();
        my $otl = $sct->outline();
        $otl->title("page $i");
        $otl->dest($page, -fit => 1);
        my $otl1 = $sct->outline();
        $otl1->title("page otl1 $i");
        $otl1->dest($page, -xyz => [100,200,5.96]);
    }
}

my $date =  (sprintf "%02d", localtime->mday())
                .'.'
                .(sprintf "%02d", localtime->mon() + 1)
                .'.'
                .(sprintf "%4d", localtime->year() + 1900);
                
                
$pdf->info('Author' => 'Matthias Hofmann',
           'Title' => 'Testpdf',
           'CreationDate' => $date);



$pdf->saveas('C:\dummy\test.pdf');

my $dummy;