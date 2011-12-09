#!/usr/bin/perl -w
use strict;

package Sizers;
use Wx qw(:everything);
use base qw(Wx::App);

sub OnInit {
    my @app = @_;
 
    my $frame = Wx::Frame->new(undef, -1, 'Sizers test');
    my $panel = Wx::Panel->new($frame, -1);
    
    my $sizer = Wx::BoxSizer->new(wxVERTICAL);
    
    my $button = Wx::Button->new($frame, -1, 'Click Me');
    $sizer->Add($button, 1, &Wx::wxEXPAND);
    my $button2 = Wx::Button->new($frame, -1,'DO NOT CLICK');
    $sizer->Add($button2, 2, &Wx::wxEXPAND);




    $frame->SetSizer($sizer);
    $frame->Show(1);
    $app[0]->SetTopWindow($frame);

    return 1;
}    


package main;
Sizers->new->MainLoop;