#!/usr/bin/perl -w
use strict;
use Tk;
#use PPEEMS::APB_STL_NC::apb_mvc;

#my $p = 'R:\090477_ps\bps_stklisten\220180_BUEHNE      +61500_2010.07.06.txt';
my $p = $ARGV[0];

my $mw = MainWindow->new(-title => 'APBDRAWING');
#my $mvc = PPEEMS::APB_STL_NC::apb_mvc->new(pfad => $p);
#$mvc->widgets($mw => [qw/view1/]);
#$mvc->init();
$mw->Label(-text => $p)->pack;

Tk::MainLoop();