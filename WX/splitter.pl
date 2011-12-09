#!/usr/bin/perl -w
use strict;

package splitter;
use Wx qw/:everything/;
use base qw(Wx::App);

sub OnInit {
    my @app = @_;
    
    my $mf = Wx::Frame->new(undef, -1, 'Panel test');#, [-1,-1], [500,500]);
    $mf->SetIcon(Wx::GetWxPerlIcon());
    
    my $p = Wx::Panel->new($mf, -1);#, [-1, -1], [400, 400] );
    
    my $splitter = Wx::SplitterWindow->new($p, -1, [-1, -1], [500, 500], wxSP_3D|wxSP_LIVE_UPDATE);
    
    my $po = Wx::Panel->new($splitter, -1);#,[0,0], [400,200]);
    $po->SetBackgroundColour(wxRED);
    my $pu = Wx::Panel->new($splitter, -1);#,[0,0], [400,200]);
    $pu->SetBackgroundColour(wxBLUE);
    
   
    my $label1 = Wx::StaticText->new($pu, -1, 'Label 1', [-1, -1], [-1, -1]);
    
    my $label2 = Wx::StaticText->new($po, -1, 'Label 2', [-1, 1], [-1, -1]);
    
    
    $splitter->SplitHorizontally($po, $pu, 200);
    
    $mf->Show(1);
    
    $app[0]->SetTopWindow($mf);
    
    return 1;
}

package main;
splitter->new->MainLoop;