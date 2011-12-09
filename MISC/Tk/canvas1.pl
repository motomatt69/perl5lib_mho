#!/usr/bin/perl -w
use strict;
use Tk;
use Misc::Tk::bltr;

my @size = (600, 400, 30 , 60, 10);

my $crosec = Misc::Tk::bltr->new({h  => $size[0],
                                  b  => $size[1],
                                  ts => $size[2],
                                  tg => $size[3],
                                  aw  => $size[4]
                                 });


my $mw = MainWindow -> new(-title=>'Blechträger');

my $canvas = $mw->Canvas(-background => 'white',
                         -height => 500,
                         -width => 500,
                         )->pack();

my $plates_ref = $crosec->get_plates;

foreach my $plate (@$plates_ref) {
           $plate = $canvas->createPolygon(@$plate,
                                    -fill => '#d77a9d',
                                    -outline => 'black',
                                        -width => 2);
}

my $snaht_ref = $crosec->get_snaht();

foreach my $snaht (@$snaht_ref){
           $snaht = $canvas->createPolygon(@$snaht,
                                       -fill => 'red4',
                                       -outline => 'black',
                                       -width => 1);
}

my ($dimlines_ref, $dimtxt_ref) = $crosec->get_dim();

foreach my $dimline (@$dimlines_ref){
           $dimline = $canvas->createLine(@$dimline,
                                        -arrow => 'last',
                                         );
}

foreach my $dimtxt (@$dimtxt_ref){
    my $txt = shift @$dimtxt;
    $txt = $canvas->createText(@$dimtxt,
                               -text => $txt
                               );
}

my ($syslines_ref) = $crosec->get_sysline();

foreach my $sysline (@$syslines_ref){
           $sysline = $canvas->createLine(@$sysline,
                                          -fill => 'grey' 
                                       );
}
    
my $bto_exit = $mw ->Button(-text => "Ende", -command => \&do_exit) ->pack();

MainLoop();


sub do_exit{
    exit;
}