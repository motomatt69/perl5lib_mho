#!/usr/bin/perl -w
use strict;
use Tk;
use STATIK::CROSEC::mvc_crosec;

my $mw = MainWindow->new(-title => 'Querschnittswerte HWS Profile');
my $mvc = STATIK::CROSEC::mvc_crosec->new();
$mvc->widgets($mw => [qw/Application/]);
$mvc->init();

MainLoop;