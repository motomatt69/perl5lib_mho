#!/usr/bin/perl -w
use strict;
use PROFILE::BLTR::canv2pdf;
use Tk;

my $mw = MainWindow->new();

my $canv = $mw->Canvas(-background => 'white',
                       -height => 500,
                       -width => 353,
                        )->pack();

my $line = $canv->createLine(10,10,300,400);

my $text = $canv->createText(50,50,-text => 'Ich bin ein Text');

my $exit_b = $mw ->Button(-text => "ende")->pack();
my $pdf_b = $mw ->Button(-text => "pdf")->pack();
$exit_b->configure(-command => sub{do_exit()}); 

$pdf_b->configure(-command => sub{do_pdf($canv)}); 

MainLoop;


sub do_exit{exit};

sub do_pdf{
    my ($canv) = @_;
    
    my $pdf->PROFILE::BLTR::canv2pdf->new($canv);
}
