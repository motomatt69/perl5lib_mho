#!/usr/bin/perl -w
use strict;
use warnings;

AUITest->new->MainLoop;

package AUITest;
use base qw(Wx::App);
use Wx qw (:everything);
use Wx::Event qw(:everything);
use Wx::AUI;
use WX::wx_gridtest;

sub OnInit {
    my (@app) = @_;

    my $mf = Wx::Frame->new( undef, -1, 'AUI Test', [-1,-1], [640, 480]);
    my $panel = Wx::Panel->new( $mf, -1);
    
    my $nb = Wx::AuiNotebook->new($panel, -1, [-1,-1], [640, 480], wxAUI_NB_TAB_EXTERNAL_MOVE);
   
    
    my $sp1 = Wx::ScrolledWindow->new($nb, -1);
    my $sp2 = Wx::ScrolledWindow->new($nb, -1);
    
    $sp1->SetScrollbars(10, 5, 40, 80, 0, 1);
    $sp2->SetScrollbars(10, 5, 20, 40, 0, 1);
    
    WX::wx_gridtest::insert_grid($sp1);
    
    $nb->AddPage($sp1, 'Subpanel 1');
    
    
    $nb->AddPage($sp2, 'Subpanel 2');
    
    
    $mf->Show(1);
    
    $app[0]->SetTopWindow($mf);
    
    return 1;
}


