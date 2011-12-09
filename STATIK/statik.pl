#!/usr/bin/perl -w
use strict;
use Tk;
use STATIK::mvc_statik;

my $mw = MainWindow->new(-title => 'Statik');
my $mvc = STATIK::mvc_statik->new();
$mvc->widgets($mw => [qw/Application/]);
$mvc->init();

MainLoop;