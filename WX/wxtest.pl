#!/usr/bin/perl -w
use strict;
use warnings;

package wxtest;
use Wx qw/ :everything/;
use base qw (Wx::App);
use Wx::Event qw/ :everything/;

sub OnInit{
    my $app = shift;
    
    my $frame = Wx::Frame->new(
        undef,
        -1,
        'Mein erstes Programm',
        [-1, -1],
        [250, 200],
    );
    
    EVT_PAINT($frame, \&_neuzeichnen);
    
    
    
    $frame->Show();

    
    1;

}

sub _neuzeichnen{
    my ($frame, $e) = @_;
    
    my $dc = Wx::PaintDC->new($frame);
    $dc->SetBrush(Wx::Brush->new(&Wx::wxGREEN, &Wx::wxSOLID));
    $dc->DrawRectangle(0, 0, 20, 30);
    
    $dc->SetPen( wxBLACK_PEN );
    $dc->DrawLine( 0, 0, 100, 100 );
    
    
}
package main;
wxtest->new->MainLoop;
