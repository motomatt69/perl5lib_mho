#!/usr/bin/perl -w
use strict;

use Tk;

my $fenster = MainWindow->new;

my $text=$fenster->Label("-text"=> "Hallo Welt");
$text->pack();
MainLoop;




