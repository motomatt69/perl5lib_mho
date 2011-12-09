#!/usr/bin/perl -w
use strict;
use warnings;

use pdf::API2;


use constant mm => 25.4 / 72;
my $pdf = PDF::API2->new (-file => 'C:/dummy/test1.pdf');
my $page = $pdf->page;

$page->mediabox (105/mm, 148/mm);
$page->cropbox (7.5/mm, 7.5/mm, 97.5/mm, 140.5/mm);

my %font = (
            Helvetica => {
                          Bold   => $pdf->corefont('Helvetica-Bold',    -encoding => 'latin1' ),
                          Roman  => $pdf->corefont('Helvetica',         -encoding => 'latin1' ),
                          Italic => $pdf->corefont('Helvetica-Oblique', -encoding => 'latin1' ),
                         },
            Times => {
                          Bold   => $pdf->corefont('Times-Bold',        -encoding => 'latin1' ),
                          Roman  => $pdf->corefont('Times',             -encoding => 'latin1' ),
                          Italic => $pdf->corefont('Times-Italic',      -encoding => 'latin1' ),
                     }
           );
        
my $blue_box = $page->gfx;
$blue_box->fillcolor('darkblue');
$blue_box->rect(5/mm, 125/mm, 95/mm, 18/mm );
$blue_box->fill;

my $red_line = $page->gfx;
$red_line->strokecolor('red');
$red_line->move( 5/mm, 125/mm);
$red_line->line( 100/mm, 125/mm);
$red_line->stroke;


$pdf->save;
$pdf->end;