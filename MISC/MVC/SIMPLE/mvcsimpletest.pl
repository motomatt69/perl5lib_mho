#!/usr/bin/perl -w
use strict;
use Tk;
use MISC::MVC::SIMPLE::mvc;

my $mw = MainWindow->new();
my $mvc = MISC::MVC::SIMPLE::mvc->new(widget => $mw);
$mvc->init();

MainLoop;

