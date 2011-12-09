#!/usr/bin/perl -w
use strict;
use Tk;
use MISC::textwindowsubject;
use MISC::textwindowobserver;

my $Subject = MISC::textwindowsubject->new();
my $textwindow = MISC::textwindowobserver->new();

$Subject->addObserver($textwindow);

$Subject->set_data();
my $dummy;
#my $mw = MainWindow->new();
#
#my $trace_t = $mw->Scrolled("Text")->pack();
#
#for my $i (1..10){
#    my $txt = $i." text\n";
#    printtrace($txt)
#}
#
#my $exit_b = $mw ->Button(-text => "ende")->pack();
#
#
#$exit_b->configure(-command => sub{exit}); 
#
#Tk::MainLoop;
#
#sub printtrace{
#    my ($text) = @_;
#    $trace_t->insert('end', $text);
#}