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


my $btoOk=$mw->Button(-text=>'ok',
                      -command=> sub {Farbe()})->pack;
MainLoop;

sub Farbe {
    $lbx->configure(-background=>$lbx->get($lbx->curselection()));
}