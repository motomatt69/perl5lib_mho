#!/usr/bin/perl -w

use warnings;

ButtonDemo->new->MainLoop;

package ButtonDemo;

use base qw(Wx::App);
use Wx;
use Wx::Event qw( EVT_BUTTON );

sub OnInit {
 my $frame = Wx::Frame->new( undef, -1, 'Kapitel 4: Jim stellt sich vor', [-1,-1], [-1, -1]);
 my $jim = Wx::Button->new( $frame, 1, ' Drück mich ', [10, 10], [50, 20]);
    EVT_BUTTON($frame, $jim, sub {$_[0]->Close(1)});
    $frame->Show(1);
}