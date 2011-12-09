#!/usr/bin/perl -w
use strict;
use Tk;
use PPEEMS::SHOPDWG1::shop_mvc;

my $mw = MainWindow->new(-title => 'SHOPDRAWING');
my $mvc = PPEEMS::SHOPDWG1::shop_mvc->new();
$mvc->widgets($mw => [qw/view1/]);
$mvc->init();

Tk::MainLoop();