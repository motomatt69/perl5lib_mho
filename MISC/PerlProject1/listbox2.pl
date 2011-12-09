#!/usr/bin/perl -w
use strict;
use Tk;


#Zeugs definieren
my $mw = MainWindow->new;

my $bto_aufausw=$mw->Button(-text=>'Auftrag',
                            -command=>sub {aufausw()});
my $auf = 012345;
my $lbl_auf=$mw->Label(-text=>$auf);

my $bto_exit =$mw->Button (-text=>"exit",
                       -command=> sub {exit(0)});
#Zeugs anordnen
$bto_aufausw->grid(-row=>0,-column=>0);
$lbl_auf->grid(-row=>0,-column=>1);
$bto_exit->grid(-row=>0,-column=>2);

MainLoop;

sub aufausw {
use DB::auftragDBmho;

my $dbh = connect();

$dbh->disconnect();
print "Verbindung geschlossen\n";

exit (0);
    
    
    
my @colors= qw/Black red4 DarkGreen NavyBlue gray75 Red Green Blue gray50
            Yellow Cyan Magenta White Brown DarkSeaGreen DarkViolett/;

my $popup=$mw->Toplevel;
my $lbx = $popup->Scrolled('Listbox',
                        -scrollbars=>'e',
                        -selectmode=>'single')->pack;

$lbx->insert('end',@colors);
$lbx->bind('<Button-1>',
           sub {$lbx->configure(-background=>$lbx->get($lbx->curselection()));
           });


my $btoOk=$popup->Button(-text=>'ok',
                      -command=> sub {$popup->destroy if Tk::Exists($popup)})->pack;

}