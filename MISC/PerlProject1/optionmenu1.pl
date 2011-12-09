#!/usr/local/bin/perl
use Tk;
# Main Window
$mw = new MainWindow;
my $scb=$mw->Scrollbar();
my $var;
my $opt = $mw -> Optionmenu(-options => [qw(January February March April)],
        -command => sub { print "got: ", shift, "\n" },
        -variable => \$var,
        -yscrollcommand=>['set'=>$scb]);

$scb->configure(-command=>['yview'=>$opt]);
$opt->addOptions([May=>5],[June=>6],[July=>7],[Augest=>8]);

$scb->pack(-side=>'right',-fill=>'y');
$opt->pack(-side=>'left', -fill=>'both');

$mw->Label(-textvariable=>\$var, -relief=>'groove')->pack;
$mw->Button(-text=>'Exit', -command=>sub{$mw->destroy})->pack;

MainLoop;
