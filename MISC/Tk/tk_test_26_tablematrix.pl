#!/usr/bin/perl -w
use strict;
use warnings;

use Tk;
use Tk::TableMatrix;
use Tk::DialogBox;

my $mw = MainWindow->new;

my $tm = $mw->Scrolled("TableMatrix",
                        -scrollbars => "se");
		
							my %tabelle = ( '1,1' => 'Block',
											'1,2' => 'TS',
		'0,3' => 'HWS Tonnen',				'1,3' => 'ges',
											'1,4' => 'frei',
											'1,5' => 'rest',
											'1,6' => '%',
											'1,7' => 'gef',
											'1,8' => 'rest',
											'1,9' => '%',
		'0,10' => 'HWS Stueck',				'1,10' => 'ges',
											'1,11' => 'frei',
											'1,12' => 'rest',
											'1,13' => 'gef',
											'1,14' => 'rest',
		'0,15' => 'Profile Tonnen',			'1,15' => 'ges',
											'1,16' => 'frei',
											'1,17' => 'rest',
											'1,18' => '%',
											'1,19' => 'gef',
											'1,20' => 'rest',
											'1,21' => '%',
		'0,22' => 'Profile Stueck', 		'1,22' => 'ges',
											'1,23' => 'frei',
											'1,24' => 'rest',
											'1,25' => 'gef',
											'1,26' => 'rest',
		'0,27' => 'HWS + Profile Tonnen', 	'1,27' => 'ges',
											'1,28' => 'frei',
											'1,29' => 'rest',
											'1,30' => '%',
											'1,31' => 'gef',
											'1,32' => 'rest',
											'1,33' => '%',
		'0,34' => 'HWS + Profile Stueck',	'1,34' => 'ges',
											'1,35' => 'frei',
											'1,36' => 'rest',
											'1,37' => 'gef',
											'1,38' => 'rest',
											
			   
			   
				
			);
$tm->configure(
        -rows           => 5,
        -cols           => 38,
        -titlerows      => 2,
        -titlecols      => 1,
        -variable       => \%tabelle,
        -colstretchmode => 'unset',
		-resizeborders => 'none',
		-state			=> 'disabled',
        -selectmode     => 'single',
        -background     => 'white',
    );                       
$tm->pack(-expand => 1,
          -fill => 'both');

$tm->spans('0,3','0,6');
$tm->spans('0,10','0,4');
$tm->spans('0,15','0,6');
$tm->spans('0,22','0,4');
$tm->spans('0,27','0,6');
$tm->spans('0,34','0,4');

$tm->tagConfigure('SEL_ROW',   -background => 'lightblue');
$tm->tagConfigure('GREY',      -background => 'lightgrey');

$tm->bind( '<MouseWheel>', [ sub { $_[0]->yviewScroll(-($_[1]/120)*3, 'units'); }, Tk::Ev('D') ] );


$tm->configure(-browsecmd  => sub {
    my ($prev, $act) = @_;
    
    my ($rp, $cp) = split ',', $prev;
    my ($ra, $ca) = split ',', $act;
	
    return if (!$rp || $rp == 0);
    return if !$ca;
    
	print "$ra, $ca\n";
	
	$tm->tagRow('DUMMY', $rp);
	$tm->tagRow('SEL_ROW', $ra);
	
	($ra > 0) && ($ca == 1) || return;
	
	my $rc = join ',', ($ra, $ca);
	my $var = $tm->cget('-variable');
	$var->{$rc} = !$var->{$rc}; #Werte vertauschen
 
	my $tag = ($var->{$rc}) ? 'ckbto_1' : 'ckbto_0';
	$tm->tagCell($tag, $rc);
	
	$tm->update();
});

MainLoop;
