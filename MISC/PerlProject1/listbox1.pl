#!/usr/bin/perl -w
use strict;
use Tk;

my @colors= qw/Black red4 DarkGreen NavyBlue gray75 Red Green Blue gray50
            Yellow Cyan Magenta White Brown DarkSeaGreen DarkViolett/;

my $mw = MainWindow->new;


my $lbx = $mw->Scrolled('Listbox',
                        -scrollbars=>'e',
                        -selectmode=>'single')->pack;

$lbx->insert('end',@colors);
$lbx->bind('<Button-1>',
           sub {$lbx->configure(-background=>$lbx->get($lbx->curselection()));
           });


my $btoOk=$mw->Button(-text=>'ok',
                      -command=> sub {exit(0)})->pack;

MainLoop;

