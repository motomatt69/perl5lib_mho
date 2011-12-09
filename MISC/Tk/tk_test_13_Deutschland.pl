#!/usr/bin/perl -w
use strict;
use Tk;

my $mw =MainWindow-> new;

my $frm01 = $mw->Frame(-width => 1000,
                        -height => 250,
                        -bg => 'black');
my $frm02 = $mw->Frame(-width => 1000,
                        -height => 250,
                        -bg => 'red');
my $frm03 = $mw->Frame(-width => 1000,
                        -height => 250,
                        -bg => 'yellow');
$frm01->pack(-side=>'top');
$frm02->pack(-side=>'top');
$frm03->pack(-side=>'top');

MainLoop;