#!/usr/bin/perl -w
use strict;
use Tk;

my $palette;
my @colors= qw/Black red4 DarkGreen NavyBlue gray75 Red Green Blue gray50
            Yellow Cyan Magenta White Brown DarkSeaGreen DarkViolett/;

my $mw = MainWindow->new;
my $om = $mw->Optionmenu(
                         -variable=> \$palette,
                         -options=> [@colors],
                         -command=> [sub {print "args=@_.\n"}, 'First'],
                        );
$om->pack;

MainLoop;