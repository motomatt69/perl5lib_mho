#!/usr/bin/perl -w
use strict;
use Tk;

my $mw = MainWindow->new;
my $box = $mw->Listbox(-height => 5);

my @items = qw (Eins Zwei Drei Vier Fünf Sechs Sieben Acht Neun Zehn);
foreach (@items) {
    $box->insert('end', $_);
}

my $scroll = $mw->Scrollbar(-command => ['yview', $box]);
$box->configure(-yscrollcommand => [ 'set', $scroll]);
$box->pack(-side => 'left', -fill=>'both', -expand=>1);
$scroll->pack(-side=>'right', -fill => 'y');

MainLoop;

