#!/usr/bin/perl -w
use strict;
use warnings;

GridTest->new->MainLoop;

package GridTest;
use base qw(Wx::App);
use Wx qw (:everything);
use Wx::Event qw(:everything);
use Wx::Grid;

sub OnInit {

    my $mf = Wx::Frame->new( undef, -1, 'Grid Test', [-1,-1], [640, 480]);
    my $panel = Wx::Panel->new( $mf, -1);
    
    my $grid = Wx::Grid->new( $mf,  -1,  [-1, -1], [640, 480]);
    
    $grid->CreateGrid(20,20);
    
    $grid->SetCellValue(1, 1, 100);
    $grid->SetReadOnly(1, 0);
    $grid->SetCellValue(1, 0, "This is read-only" );
    $grid->SetCellValue(2, 0, "coloured");
    $grid->SetCellTextColour(2, 0, Wx::Colour->new(255,0,0));
    $grid->SetCellBackgroundColour(2, 0, Wx::Colour->new(255,255,128));
    $grid->SetColFormatFloat(0, 3, 2); #spalte 0, ?, 2 stellen hinterm komma 
    $grid->SetCellValue(3, 0, "3223.1415");
    
    $grid->SetRowSize( 1, 100 );
    $grid->SetColSize( 2, 200 );

    $grid->SetColLabelValue(0,"Column 0 Label Value");
    $grid->SetRowLabelSize(150);
    $grid->SetRowLabelValue(0,"Row 0 Label Value");

    
    for my $r (0..20){
        for my $c (1..3){
            $grid->SetCellValue($r, $c, 200)
        }
    }
    
    
    
    $panel->SetAutoLayout(1);     
    $mf->Show(1);
}