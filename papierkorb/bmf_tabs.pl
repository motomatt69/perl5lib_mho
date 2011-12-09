#!/usr/bin/perl -w
use strict;
use Tk;
use PPEEMS::BMF_TABS::bmf_tabs_mvc;

my $mw = MainWindow->new(-title => 'BMF Tabellen');
my $mvc = PPEEMS::BMF_TABS::bmf_tabs_mvc->new();
$mvc->widgets($mw => [qw/view1/]);
$mvc->init();

Tk::MainLoop();


