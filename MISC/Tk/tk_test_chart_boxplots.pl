#!/usr/bin/perl
  use strict;
  use warnings;
  use Tk;
  use Tk::Chart::Boxplots;
  
  my $mw = new MainWindow(
    -title      => 'Tk::Chart::Boxplots example',
    -background => 'white',
  );
  
  my $Chart = $mw->Boxplots(
    -title      => 'My graph title',
    -xlabel     => 'X Label',
    -ylabel     => 'Y Label',
    -background => 'snow',
  )->pack(qw / -fill both -expand 1 /);
  
  my $one   = [ 210 .. 275 ];
  my $two   = [ 180, 190, 200, 220, 235, 245 ];
  my $three = [ 40, 140 .. 150, 160 .. 180, 250 ];
  my $four  = [ 100 .. 125, 136 .. 140 ];
  my $five  = [ 10 .. 50, 100, 180 ];
  
  my @data = (
    [ '1st', '2nd', '3rd',  '4th', '5th' ],
    [ $one,  $two,  $three, $four, $five ],
    [ [-25, 1..15], [-45, 25..45, 100], [70, 42..125], [undef], [180..250] ],
    # ...
  );
  
  # Add a legend to the graph
  my @Legends = ( 'legend 1', 'legend 2' );
  $Chart->set_legend(
    -title       => 'Title legend',
    -data        => \@Legends,
  );
  
  # Add help identification
  $Chart->set_balloon();
  
  # Create the graph
  $Chart->plot( \@data );
  
  MainLoop();
