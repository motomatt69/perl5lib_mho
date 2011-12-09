#!/usr/bin/perl -w
use strict;
#!perl
# file progress.pl
use Tk;
use Tk::ProgressBar;
use strict;
my $percent_done = 0;
my $mw = MainWindow->new;
my $text = "Percentage to date: $percent_done";
$mw->title('Progress Bar');
my $message = $mw->Message(-textvariable => \$text,
                           -width => 130,
                           -border => 2);
my $progress = 
  $mw->ProgressBar(-width => 200,
                   -height => 20,
                   -from => 0,
                   -to => 100,
                   -anchor => 'e',
                   -blocks => 5,
                   -colors => [0, 'green', 50, 'yellow' , 80, 'red'],
                   -variable => \$percent_done,
                   );
my $exit = $mw->Button(-text => 'Exit',
                     -command => [$mw => 'destroy']);
#my $get = $mw->Button(-text => 'Press to start!',
#                      -command => \&start);
#&start;
#$get->pack;
$progress->pack;
$message->pack;
$exit->pack;
&start;
MainLoop;


sub start {
  for ($percent_done=0; $percent_done <= 100; $percent_done +=5) {
   $text = "Percentage to date: $percent_done";
    $mw->update;
    sleep 1;
  }
 $text = 'Done!';
  $mw->update;
}

