#!/usr/bin/perl -w
use strict;

use Tk;
use Tk::TableMatrix;

main();

sub main
{
	my $top = MainWindow->new;

	my $data = {};
	$data->{"5,1"} = 13;
	
	my ($rows,$cols) = (12,2); # number of rows/cols

	# create the table
	my $t = $top->Scrolled
		(TableMatrix =>
		 -rows => $rows,
		 -cols => $cols,
		 -titlerows =>  1,
		 -titlecols => 1,
		 -width => 8, -height => 8 ,
		 -colwidth => 11,
		 -variable => $data,
		 -cursor => 'top_left_arrow' ,
		 -borderwidth => 2 ,
		 -ipadx => 15,
		 -scrollbars => 'se',
		)->pack(qw/-expand 1 -fill both/);
	
	my $tm = $t->Subwidget('scrolled');

	
	
	
	Tk::MainLoop;
}


#--------------------------------------------------------------

sub define_bitmaps{
	my ($w) = @_;

my $cbutton0 =
'
/* XPM */
static char * xpm[] = {
"9 8 3 1",
" 	c None",
"@	c #B8B8B8",
"+	c #555555",
"+++++++++",
"++++++++@",
"++     @@",
"++     @@",
"++     @@",
"++     @@",
"++@@@@@@@",
"+@@@@@@@@"};
};
';

my $cbutton1 =
'
/* XPM */
static char * xpm[] = {
"9 8 4 1",
" 	c None",
"@	c #B8B8B8",
"+	c #555555",
".	c #FF0000",
"+++++++++",
"++++++++@",
"++.....@@",
"++.....@@",
"++.....@@",
"++.....@@",
"++@@@@@@@",
"+@@@@@@@@"};
};
';

	my %images;
	$images{checkbutton0} = $w->Pixmap('cbutton0', -data => $cbutton0);
	$images{checkbutton1} = $w->Pixmap('cbutton1', -data => $cbutton1);
	%images;
}
