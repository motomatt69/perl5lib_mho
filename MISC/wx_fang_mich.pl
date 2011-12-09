#!/usr/bin/perl -w
use strict;
use warnings;

ButtonDemo->new->MainLoop;

package ButtonDemo;

use base qw(Wx::App);
use Wx;
use Wx::Event qw( EVT_BUTTON );

sub OnInit {
 my $frame = Wx::Frame->new( undef, -1, 'Kapitel 4: fangt Jim', [-1,-1], [110, 110]);
    EVT_BUTTON($frame, Wx::Button->new( $frame, 1, ' Fang mich !'), \&spring_weg);
    $frame->Show(1);
}

sub spring_weg {
   my $frame = shift;
   my $screen = Wx::GetDisplaySize();
   my ($x_size, $y_size) = $frame->GetSizeWH();
   my $x_pos = int rand $screen->GetWidth - $x_size;
   my $y_pos = int rand $screen->GetHeight - $y_size;
   $frame->SetSize($x_pos, $y_pos, $x_size, $y_size);
}


