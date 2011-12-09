# This code in file main.pl.

#!/usr/bin/perl
package MyApp;

use warnings;
use strict;
use Wx;
#use AppFrame;

use vars qw( @ISA );
our @ISA = qw( Wx::App );

sub OnInit
{
    my $self = shift;

    # Create new main application frame.
    my $frame = AppFrame->new( "Test DrawPolygon", Wx::Point->new( 50, 50 ), Wx::Size->new( 640, 480 ) );

    $frame->SetBackgroundColour( Wx::wxBLUE );

    $self->SetTopWindow( $frame );

    $frame->Center();
    $frame->Show( 1 );

    return 1;
}


package main;

my( $app ) = MyApp->new();

$app->MainLoop();



# This code in file AppFrame.pm.

#!/usr/bin/perl
package AppFrame;

use warnings;
use strict;
use Wx;
#use MyCanvas;

our ( @ISA ) = qw( Wx::Frame );

sub new
{
    my $class = shift;
    $class = ref( $class ) || $class;
    my ( $title, $pos, $size ) = @_;

    $title = defined( $title ) ? $title : "wxPerl";
    $pos   = defined( $pos )   ? $pos   : Wx::Point->new( 0, 0 );
    $size  = defined( $size )  ? $size  : Wx::Size->new( 50, 50 );

    my $self = $class->SUPER::new( undef, -1, $title, $pos, $size );
    bless( $self, $class );

    # Create canvas.
    $self->{CANVAS} = MyCanvas->new( $self, -1, $pos, $size );

    return $self;
}


return 1;



# This code in file MyCanvas.pm.

#!/usr/bin perl
package MyCanvas;

use warnings;
use strict;
use Wx;

our ( @ISA ) = qw( Wx::Panel );

sub new
{
    my ($class, $parent, $id, $pos, $size) = @_;
    $class = ref( $class ) || $class;

    $id    = defined( $id )   ? $id   : -1;
    $pos   = defined( $pos )  ? $pos  : Wx::wxDefaultPosition;
    $size  = defined( $size ) ? $size : Wx::wxDefaultSize;

    my $self = $class->SUPER::new( $parent, $id, $pos, $size );
    bless( $self, $class );

    $self->SetBackgroundColour( Wx::wxBLUE );

    use Wx::Event qw( EVT_PAINT );

    EVT_PAINT( $self, \&on_paint );

    return $self;
}

use Wx qw( wxGREEN_PEN wxGREEN_BRUSH );

sub on_paint
{
    my ($self, $event) = @_;
    my $dc = Wx::PaintDC->new( $self );

    $dc->SetPen( wxGREEN_PEN );
    $dc->SetBrush( wxGREEN_BRUSH );
    $dc->DrawPolygon( [ Wx::Point->new(319, 239), Wx::Point->new(311, 236), Wx::Point->new(311, 242) ], 0, 0 );
}


return 1;