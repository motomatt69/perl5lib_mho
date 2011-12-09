#!/usr/bin/perl -w

use Wx qw[:allclasses];
use strict;

Apfel->new->MainLoop;

package Apfel;

use base qw(Wx::App);
use Wx::Event qw (EVT_BUTTON);

sub OnInit {
   my $frame = Wx::Frame->new( undef, -1, "Apfelmaennchen", [-1,-1], [1000,1000]);
   my $Button = Wx::Button->new($frame,-1,"Malen",[450,850],[100,50]);
   my $panel = Wx::Panel->new( $frame, -1, [0,0],[1000,8000]);
   my $dc = $frame->{dc} = Wx::MemoryDC->new();
   my $bmp = $frame->{bmp} = Wx::Bitmap->new( 800, 800 );
   $dc->SelectObject( $bmp );
   my $maltafel = $frame->{tafel} = Wx::StaticBitmap->new( $panel, -1, $bmp, [100,1]);
   $dc->Clear();
   $dc->SelectObject( $bmp );
      EVT_BUTTON($frame,$Button, \&malen);   
   
   $frame->Show(1);

sub malen {
    my ($frame, $e) = @_;
    
    
   my $pinsel = Wx::Pen->new(Wx::Colour->new('red'),5,&Wx::wxSOLID);
   my $dc = $frame->{dc};
   $dc->SetPen($pinsel);
#   $dc->DrawLine(200,200,300,300);
   for my $i (1..800){
      for my $j (1..800){
         $dc->DrawPoint($i,$j);
          }
   }
   
   $frame->{tafel}->SetBitmap( $frame->{bmp} );
   $frame->{dc}->SelectObject( $frame->{bmp} );
   $frame->{tafel}->Refresh();
}   
  
}