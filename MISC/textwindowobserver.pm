#!/usr/bin/perl -w
use strict;
use Tk;
use WIDGETS::trace;

my $mw = MainWindow->new();

my $trace_t = WIDGETS::trace->new($mw);
$trace_t->grid(0, 1);

my $data_b = $mw->Button(-text => 'data')->grid(-row => 1, -column => 0, -sticky => "nsew");
my $exit_b = $mw ->Button(-text => "ende")->grid(-row => 1, -column => 1, -sticky => "nsew");

$data_b->configure(-command => sub{data()});
$exit_b->configure(-command => sub{exit}); 

Tk::MainLoop;

sub data{
    for my $i (1..80){
        my $txt = $i." text\n";
        $trace_t->printtrace($txt);
    }
}


