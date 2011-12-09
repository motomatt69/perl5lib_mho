#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;

my $dat_ref -> {'0,0'} = ('Kopf1');
$dat_ref -> {'0,1'} = ('Kopf2');
$dat_ref -> {'0,2'} = ('Kopf3');




my $mw=MainWindow->new;
$mw->geometry("1200x500");

my $tm=$mw->Scrolled('TableMatrix',
                     -resizeborders=>'both',
			-titlerows => 1,
                        -rows => 20,
                         -colstretchmode=>'all',
                         -cols => 4,
                       -cache => 1,
                       -scrollbars => "osoe", 
			-variable => $dat_ref,
                     -bg => 'white',);

$tm->pack();
$tm->colWidth(0 => -600, 1 => -300, 2 => -300, 3 => 300); 

$tm->set("1,1", 36);

Tk::MainLoop;
