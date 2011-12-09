#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::TableMatrix;

my $dat_ref -> {'0,0'} = ('Kopf1');
$dat_ref -> {'0,1'} = ('Kopf2');
$dat_ref -> {'0,2'} = ('Kopf3');




my $mw=MainWindow->new;
$mw->geometry("900x500");

sub rowSub{
	my $row = shift;
	#return "OddRow" if( $row > 0 && $row % 2)
        return "col1row" if( $dat_ref->{"$row,2"} eq 'test');
}

my $tm=$mw->Scrolled('TableMatrix',
                     -width => 0,
		     -rows => 5,
                     -cols => 3,
		     #-colwidth => '-60',
                     -rowtagcommand => \&rowSub, 
                     -titlerows => 1,
                     -variable => $dat_ref,
                     -bg => 'white',);

$tm->pack();
$tm->colWidth(0 => -300, 1 => -300, 2 => -300); 

$dat_ref -> {'1,0'} = ('Wert1 1');
$dat_ref -> {'1,1'} = ('Wert1 2');
$dat_ref -> {'1,2'} = ('Wert1 3');

# hideous Color definitions here:
$tm->tagConfigure('col1row', -bg => 'orange', -fg => 'purple');

my $bto=$mw->Button(-text => 'update',
                    -command => sub {update_tabelle($tm,$dat_ref)},)->pack();

Tk::MainLoop;

sub update_tabelle {
    my ($tm , $dat_ref) = @_;
    my $row;
    foreach my$i (0..10) {
        $row++;
        if ($dat_ref->{"$i,0"}){
        }else{
    $dat_ref -> {"$i,0"} = ("Wert $i 0");
    $dat_ref -> {"$i,1"} = ("Wert $i 1");
    $dat_ref -> {"$i,2"} = ("Wert $i 2");
    $dat_ref -> {"2,2"}= ('test');
    $dat_ref -> {"4,2"}= ('test');
    last;
        }
    }
    $tm->configure(-rows=> $row,);
    #$tm->configure();
    $tm->update();
}