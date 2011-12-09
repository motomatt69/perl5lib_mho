#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;



my $hashref={};
#my $mw = MainWindow->new;
#my $tm = $mw->TableMatrix(-cols => 2,
#                          -rows => 10,
#                          -variable => $hashref,);
#my $bto1 = $mw->Button(-text => 'sortieren',
#                       -command => sub {sortieren()},);



foreach my$z (0..10) {
    foreach my$s (0..1) {
     $hashref->{"$z,$s"}="$z te zeile, $s te spalte";
    }
}

my $rows=10; my$sortspalte=1;
my $zeilen=[];
foreach my$j (0..$rows) {
my@selkeys = sort (grep m/^$j,.+/, keys %$hashref); 

    my$i=0;my @datsatz;
    foreach (@selkeys) {
        $datsatz[$i]=$hashref->{$_};
    $i++;
    }
    my$zeilen->[$j] = \@datsatz;
    print @$zeilen;
    #$dathashref->{"
#print $list[0];
}

#$tm->colWidth (0 => -150, 1 => -150);

#$tm->grid(-row => 0, -column => 0); 
#$bto1->grid(-row => 1, -column => 0);

#Tk::MainLoop;  

sub sortieren {
    print "sortieren\n";
    
    
    
    
}
1;