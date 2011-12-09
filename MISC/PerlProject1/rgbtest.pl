#!/usr/bin/perl -w
use strict;
use Tk;

my $mw = MainWindow->new;
my $canvas = $mw->Canvas(-background => '#4b3f6a',
                         )->pack;


MainLoop();





