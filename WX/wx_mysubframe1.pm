package WX::wx_mysubframe1;

use Wx qw/:everything/;


use Moose;

has wx => (is => 'rw');


sub init_subframe1{
    my ($self) = @_;
    
    my $wx = $self->wx();
    
    my $frame = $wx->{frame};
    
    my $dc = Wx::PaintDC->new($frame);
    $dc->SetBrush(Wx::Brush->new(&Wx::wxGREEN, &Wx::wxSOLID));
    $dc->DrawRectangle(0, 0, 20, 30);
    
    $dc->SetPen( wxBLACK_PEN );
    $dc->DrawLine( 0, 0, 100, 100 );
    
    my $dummy;
    
}

1;