#!/usr/bin/perl -w
#http://www.ibm.com/developerworks/linux/library/l-datavis/#resources
#http://download.boulder.ibm.com/ibmdl/pub/software/dw/library/l-datavis/hexa-plot.pl
use strict;

use Tk;

# Some constants:
my $PI = 3.14159265358979323846;
my $SQRT3 = sqrt(3.0);

# Widget sizes (in screen pixels):
my $padding = 10;
my $height  = 400;
my %pane    = ( width =>  75, height => $height );
my %canvas  = ( width => 400, height => $height);
my %window  = ( width => $pane{width}+$canvas{width}+4*$padding,
		height => $height+2*$padding );

my $x11_geometry = $window{width}."x".$window{height}."+100+100";


# Plot range and resolution:
my $pix_per_pt = 2;
my %num_of_pts = ( hor => $canvas{width}/$pix_per_pt,
		   ver => $canvas{height}/$pix_per_pt );

my %plot_range = ( hor => {from=>-2.0, to=>2.0}, ver => {from=>-2.0, to=>2.0} );
my %resolution = ( hor =>
		   ($plot_range{hor}{to} - $plot_range{hor}{from})/$num_of_pts{hor},
		   ver =>
		   ($plot_range{ver}{to} - $plot_range{ver}{from})/$num_of_pts{ver} );


# Create MainWindow and configure:
my $mw = MainWindow->new;
$mw->configure( -width=>$window{width}, -height=>$window{height} );
$mw->geometry( $x11_geometry );
$mw->resizable( 0, 0 ); # not resizable in any direction
$mw->title( "Visuals" );

# Configure the side pane:
my $pane = $mw->Frame;
$pane->pack( -side=>"left", -padx=>$padding, -pady=>$padding, -fill=>"both" );
$pane->Button( -text=>"Exit", -command=>sub{ exit } )->pack( -side=>"bottom",
							     -pady=>$padding );
# Create and configure the canvas:
my $canvas = $mw->Canvas( -cursor=>"crosshair", -background=>"white",
		       -width=>$canvas{width}, -height=>$canvas{height} );
$canvas->pack( -side=>"right", -padx=>$padding, -pady=>$padding );

# Create interactive display of values
my ( $xy_label, $val_label ) = ( "", "" );
$pane->Label( -textvariable=>\$xy_label )->pack( -side=>"top" );
$pane->Label( -textvariable=>\$val_label )->pack( -side=>"top" );
$canvas->Tk::bind( "<Motion>", [ \&track_motion, Ev('x'), Ev('y'), 
				 $pix_per_pt, \%resolution, \%plot_range,
				 \$xy_label, \$val_label ] );


# Display data
my $yy = $plot_range{ver}{to};
for( my $y = 0; $y < $canvas{height}; $y += $pix_per_pt ) {
  $yy -= $resolution{ver};

  my $xx = $plot_range{hor}{from};
  for( my $x = 0; $x < $canvas{width}; $x += $pix_per_pt ) {
    $xx += $resolution{hor};

    my $value = fct( 3, 1, $xx, $yy );
    my $color = sprintf( "#%x%x%x", 255*$value, 255*$value, 255*$value );
    $canvas->createRectangle( $x, $y, $x+$pix_per_pt, $y+$pix_per_pt,
			      -fill=>$color, -outline=>$color );
  }
}


MainLoop;

# -----

sub fct {
  my ( $h, $k, $x, $y ) = @_;

  my $a = 0.5*$PI *(   $x - $SQRT3*$y );
  my $b = 0.5*$PI *( 3*$x + $SQRT3*$y );

  my $r = cos( ($h-  $k)*$a )*cos( ($h+$k)*$b ) +
          cos( ($h+2*$k)*$a )*cos( ($h   )*$b ) +
          cos( (2*$h+$k)*$a )*cos( (   $k)*$b );

  # shifting and rescaling, to make the return value fall between 0..1
  return (3.0 + $r)/6.0;
}

# -----

sub track_motion {
  my ( undef, $x, $y, $pix_per_pt, $r_res, $r_range, $r_xy_label, $r_val_label ) = @_;

  if( defined( $x ) && defined( $y ) ) {
    my $xx = $r_range->{hor}{from} + $r_res->{hor}*$x/$pix_per_pt;
    # making the y axis point up, ie inverting the canvas coordinate system:
    my $yy = $r_range->{ver}{to}   - $r_res->{ver}*$y/$pix_per_pt;

    $$r_xy_label = sprintf( "% 1.2f:% 1.2f", $xx, $yy );
    $$r_val_label = sprintf( "%2.4f", fct( 3, 1, $xx, $yy ) );
  }
}
