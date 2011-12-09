#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;

use Data::Dumper qw( DumperX);
my $top = MainWindow->new;

my $arrayVar = {};

foreach my $row  (0..20){
	foreach my $col (0..10){
		$arrayVar->{"$row,$col"} = "r$row, c$col";
	}
}



my $t = $top->Scrolled('TableMatrix', -rows => 21, -cols => 11, 
                              -width => 6, -height => 6,
			      -titlerows => 1, -titlecols => 1,
			      -anchor => 'w',
			      -variable => $arrayVar,
			      -selectmode => 'extended',
			      -resizeborders => 'both',
			      -titlerows => 1,
			      -titlecols => 1,
			      -bg => 'white',
			);
		    
$t->tagConfigure('active', -bg => 'gray90', -relief => 'sunken');
$t->tagConfigure( 'title', -bg => 'gray85', -fg => 'black', -relief => 'sunken');

# $t->bind("<Any-Enter>", sub { $t->focus });



$t->pack(-expand => 1, -fill => 'both');

Tk::MainLoop;
