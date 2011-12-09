#!/usr/bin/perl -w
use strict;
use Tk;

my $mw = MainWindow->new;
my$frm1=$mw->Frame(-relief=>'sunken',
                   -width =>'50',
                   -height=>'50',
                   -borderwidth=>'1')->pack(-side=>'top');

my $scale1 = $frm1->Scale(-from =>0, -to=>100,
                          -orient =>'vertical',
                          -label=>'Schieb mich')->pack;
MainLoop;
                          
