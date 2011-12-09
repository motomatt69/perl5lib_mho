#!/usr/bin/perl -w
use strict;
use Tk;

my $mw=MainWindow->new;
my $canv1=$mw->Canvas(-width=>350,
                    -height=>350,)->pack();
#my $rech = $canv1->createRectangle(150,150,300,300, -fill=>'green');


MainLoop;
print "test";

&aktual();
sub aktual {
    print "test";
#    #my $i=20;
#    ##while ($i <= 100) {
#    #    my $rech = $canv1->createRectangle($i+50,50,$i+100,100, -fill=>'red');
#    #    
#    #    
#    ##    $ i+= 20;
#    #    #sleep 1;
#    #    $mw->update;
#    ##}
}