#!/usr/bin/perl -w
use strict;
use Tk;

my $mw = MainWindow->new();

my$frm1=$mw->Frame(-relief=>'sunken',
                   -width =>'50',
                   -height=>'50',
                   -borderwidth=>'10')->pack(-side=>'left',
                                             -pady=>'10',
                                             -padx=>'10');

my$frm2=$mw->Frame(-relief=>'raised',
                   -width =>'50',
                   -height=>'50',
                   -borderwidth=>'10',
                   -bg=>'red')->pack(-side=>'left',
                                             -pady=>'10',
                                             -padx=>'10');

my$frm3=$mw->Frame(-relief=>'sunken',
                   -width =>'100',
                   -height=>'100',
                   -borderwidth=>'10')->pack(-side=>'left',
                                             -pady=>'10',
                                             -padx=>'10');

my $summe=0;
my $lbltext = $frm3->Label(-textvariable => \$summe)->pack;
                           
my $btoschalter1 = $frm2->Button(-text => "Rechne Summe",
                                -command=>\&ergebnis1)->pack(-anchor=>'center');

my $btoschalter2 = $frm2->Button(-text => "Rechne Multi",
                                -command=>\&ergebnis2)->pack(-anchor=>'center');

my $scale1 = $frm1->Scale(-from=>0, -to=>100,
                          -orient => 'horizontal',
                          -label =>"Zahl 1")->pack;
                          
my $scale2 = $frm1->Scale(-from=>0, -to=>100,
                          -orient => 'horizontal',
                          -label =>"Zahl 2")->pack;
                          
my $scale3 = $frm1->Scale(-from=>0, -to=>100,
                          -orient => 'horizontal',
                          -label =>"Zahl 3")->pack;

sub ergebnis1{
    $summe=$scale1->get()+$scale2->get()+$scale3->get();
}

sub ergebnis2{
    $summe=$scale1->get()*$scale2->get()*$scale3->get();
}


                          
MainLoop;
                          
