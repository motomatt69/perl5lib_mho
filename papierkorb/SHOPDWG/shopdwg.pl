#!/usr/bin/perl -w
use strict;
use Tk;
use PPEEMS::SHOPDWG::shop_mvc;

my $p = 'R:\090477_ps\bps_stklisten\229005_FACHWERKTRAEGER +88m_2010.06.24.csv';

my $mw = MainWindow->new(-title => 'SHOPDRAWING');
my $mvc = PPEEMS::SHOPDWG::shop_mvc->new(pfad => $p);
$mvc->widgets($mw => [qw/view1/]);
$mvc->init();

Tk::MainLoop();