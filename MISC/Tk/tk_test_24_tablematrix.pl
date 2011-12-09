#!/usr/bin/perl -w
use strict;
use warnings;

use Tk;
use Tk::TableMatrix;
use Tk::ProgressBarPlus;

my $mw = MainWindow->new;

my $tm = $mw->Scrolled("TableMatrix",
                        -scrollbars => "se");
$tm->configure(
        -rows           => 1,
        -cols           => 14,
        -titlerows      => 1,
        -titlecols      => 1,
        -variable       => {'0,1' => 'Block',
                            '0,2' => 'BG',
                            '0,3' => 'Cube',
                            '0,4' => 'Teilsystem',
                            '0,5' => 'Hauptteil',
                            '0,6' => 'Blatt',
                            '0,7' => 'Rev',
                            '0,8' => 'AlstomID',
                            '0,9' => 'AlstomZnr',
                            '0,10' => 'Rev',
                            '0,11' => 'Werkplan',
                            '0,12' => 'Pos.-Schild',
                            '0,13' => 'Eingangsdatum',
                            },
        -colstretchmode => 'unset',
		-resizeborders => 'none',
		-state			=> 'disabled',
        -selectmode     => 'single',
        -background     => 'white',
       # -browsecmd  => [&showSelect($tm)],
    );                       
$tm->pack(-expand => 1,
          -fill => 'both');


$tm->tagConfigure('SEL_ROW',   -background => 'lightblue');
$tm->tagConfigure('GREY',      -background => 'lightgrey');

$tm->bind( '<MouseWheel>', [ sub { $_[0]->yviewScroll(-($_[1]/120)*3, 'units'); }, Tk::Ev('D') ] );

$tm->configure(-browsecmd  => sub {
    my ($prev, $act) = @_;
    
    my ($rp, $cp) = split ',', $prev;
    my ($ra, $ca) = split ',', $act;
    
    return if (!$rp || $rp == 0);
    return if !$ca;
    
	$tm->tagRow('DUMMY', $rp);
    
#	for my $c (1..2, 7..9){
#        $tm->tagCell('GREY', "$rp,$c")
#    }


	$tm->tagRow('SEL_ROW', $ra);
	$tm->update();
});

fillTable($tm);
update_images($tm);


my $bto = $mw->Button(-text => 'Fortschritt')->pack();
$bto->configure(-command => sub{werte()});

#ProgressbarPlus
#my @colors = (0, 'khaki1', 10, 'khaki2' , 20, 'gold1', 30, 'gold2', 40, 'goldenrod1',
#                               50, 'goldenrod2', 60, 'goldenrod3', 70, 'DarkGoldenrod3', 80, 'goldenrod4', 90, 'orange4'),











my $s_col = "000080";
my $t_col = "00FF00";





my $prozent = 0;
my $f = $mw->Frame(-borderwidth => 5,
				   -relief => 'sunken'
				   
				   );
$f->pack(-expand => 1,
          -fill => 'both');

my $progress = $f->ProgressBarPlus(-width => 40,
                   -length => 500,
                   -height => 10,
                   -from => 0,
                   -to => 100,
                   -anchor => 'w',
                   -blocks => 1,
				   -troughcolor => "#BFBFBF",
                   -colors => color_array($s_col, $t_col), 
                   -variable => \$prozent,
                   -showvalue => '1',
                   -valuecolor => 'black',
                   -font => '9x15',
                   -valueformat => '%s %%',);
$progress->pack(-expand => 1,
          -fill => 'both');

MainLoop;


sub werte{
	for my $i (1..100){
		fortschritt($i);
		sleep (1/50)
	}
}

sub fortschritt {
    my ($percent_done) = @_;
    $prozent = $percent_done;
    $mw->update();
    #print "Aktueller Fortschritt $percent_done\n";
}





sub fillTable {
    my ($tm) = @_;
    
    my $table   = $tm->cget('-variable');
    my $cols    = $tm->cget('-cols') - 1;
    
    my @dcols   = (0 .. $cols);
    my $row     = 1;
    
    my @tab;
	for my $r (0..1000){
		my @row;
		for my $c (0..20){
				$row[$c] = $r + $c
		}
		push @tab, [@row]
	}
    my $liste   = \@tab;
    
    %$table = map { ("0,$_" => $table->{"0,$_"})} (1 .. $cols);
    
    for my $data (@$liste) {
        my @keys = map { $row . ',' . $_ } @dcols;
        @$table{@keys} = ($row,@$data);
        $row++;
    }
    
    $tm->configure(-rows => $row);
    $tm->selectionClear('all');
    
    $row--;
    $tm->activate("$row,1");
    $tm->see("$row,1");
    $tm->update();
}

sub update_images{
    my ($tm) = @_;
    
    my $ol = ("0,0");
    my $ur = $tm->index('bottomright');
    
    my ($rs, $cs) = split ',', $ol;
    my ($re, $ce) = split ',', $ur;
    
    for my $c (1..2, 7..9){
        $tm->tagCol('GREY', "$c")
    }
    
    for my $r (($rs + 1).. $re) {
        next if ($tm->get("$r,19") eq '-');
        $tm->tagCell('ckbto_0', "$r,19");
    }
    $tm->yview(0);
    $tm->update();
}

sub color_array{
	my ($s_col, $t_col) = @_;

	my ($sr, $sg, $sb) = $t_col =~ m/(\S{2})(\S{2})(\S{2})/;
	my ($tr, $tg, $tb) = $s_col =~ m/(\S{2})(\S{2})(\S{2})/;
	
	($sr, $tr) = (hex($sr), hex($tr));
	my $fak_r = ($tr - $sr) / 100;
	($sg, $tg) = (hex($sg), hex($tg));
	my $fak_g = ($tg - $sg) / 100;
	($sb, $tb) = (hex($sb), hex($tb));
	my $fak_b = ($tb - $sb) / 100;
	
	my @col_dezi;
	for (my $t = 100; $t >= 0 ; $t -= 1){
		push @col_dezi, [int($sr + $t * $fak_r), int($sg + $t * $fak_g), int($sb + $t * $fak_b)];
	}
	
	my @col_hex;
	my $cnt = 1;
	for my $row (@col_dezi){
		push @col_hex, $cnt;
		my $color = sprintf("#%02X%02X%02X", $row->[0], $row->[1], $row->[2]);
	
		push @col_hex, $color;
		$cnt ++
	}
	
	return \@col_hex;
}
	
	