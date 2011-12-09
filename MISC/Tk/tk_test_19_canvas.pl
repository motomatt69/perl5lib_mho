#!/usr/bin/perl -w
use strict;

use Tk;

my $mw = MainWindow->new;
my $cvs1 = $mw->Canvas(-width=>350,
                       -height=>350,)->pack();

$cvs1->createLine(25, 175, 325,175, -arrow=>'last');
$cvs1->createText(15, 175, -fill=>'blue', -text=>'X');
$cvs1->createLine(175, 25, 175, 325, -arrow=>'last');
$cvs1->createText(175, 15, -fill=>'red', -text=>'Y');

my $bto1 = $mw->Button(-text=>"createArc",
                    -command=>sub {arc()})->pack(-side=>'left');
my $bto2 = $mw->Button(-text=>"createLine",
                    -command=>sub {line()})->pack(-side=>'left');
my $bto3 = $mw->Button(-text=>"createOval",
                    -command=>sub {oval()})->pack(-side=>'left');
my $bto4 = $mw->Button(-text=>"createRectangle",
                    -command=>sub {rect()})->pack(-side=>'left');
my $bto5 = $mw->Button(-text=>"createText",
                    -command=>sub {text()})->pack(-side=>'left');
my $bto6 = $mw->Button(-text=>"Exit",
                    -command=>sub {exit 0})->pack(-side=>'left');
MainLoop;

                       
sub arc{
    $cvs1->createArc(25,100,150,300,-fill=>'blue')
}

sub line {
    $cvs1->createLine(25, 25, 325, 325, -fill=>'red')
}

sub oval {
    $cvs1->createOval(35,25,100,100, -fill =>'yellow')
}

sub rect {
    my $y=100;
    $cvs1->createRectangle(150,150,300,$y, -fill=>'green');
}

sub text {
    $cvs1->createText(175,10, -text => 'Dies ist ein Textbeispiel')
}