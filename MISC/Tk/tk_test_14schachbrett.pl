#!/usr/bin/perl -w
use strict;

use Tk;

my @colors=qw(black yellow);
my $mw=MainWindow->new;

# Hauptfenster in linken und rechten Bereich aufteilen
my $mainfrm_left =$mw->Frame(-width=>200, -height=>200)->pack(-side=>'left');
my $mainfrm_right =$mw->Frame(-width=>200, -height=>200, bg => 'green')->pack(-side=>'left');

#Im linken Bereich Schachbrett darstellen
foreach my $i (1..8) {
    my $frm_row = $mainfrm_left -> Frame->pack(-side=>'top'); #8 Reihen
    foreach my $j (1..8) {
        my $frm_cell = $frm_row->Frame(-width => 25, -height => 25, -bg => $colors[($i + $j) % 2]);
        # gerade Zahlen schwarz, ungerade weiß
        $frm_cell->pack(-side=>'left');
    }
}

#Im rechten Bereich Relief darstellen

my $frm_rel1 = $mainfrm_right->Frame(-relief =>'ridge',
                                     -width =>200,
                                     -height => 200,                                     
                                     -bg => 'red',
                                     -borderwidth => 10)->pack(-side=>'top');
my $text1 = $frm_rel1->Label(-text=>'relief')->pack();
my $frm_rel2 = $mainfrm_right->Frame(-relief =>'groove',
                                     -width =>200,
                                     -height => 200,
                                     -bg => 'green',
                                     -borderwidth => 10)->pack(-side=>'bottom');
my $text2 = $frm_rel2->Label(-text=>'groove')->pack();
MainLoop;
