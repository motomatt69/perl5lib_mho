#!/usr/bin/perl -w
use strict;

package flaechen;
use Wx qw/:everything/;
use base qw(Wx::App);

sub OnInit {
    my @app = @_;
    
    my $mf = Wx::Frame->new(undef, -1, 'Panel test');
    my $po = Wx::Panel->new($mf, -1);
    
    my $box = Wx::StaticBoxSizer->new(Wx::StaticBox->new($po, -1, 'Box'),
                                      wxVERTICAL
                                      );
    my @std = (0, wxALL, 5);
    my @rb = map{Wx::RadioButton->new($po, -1, 'Radiobutton'.$_)} 1..3;
    $box->Add($_, @std) for @rb;
    
    $box->Add(Wx::CheckBox->new($po, -1, 'Haken'), @std);
    
    my $rsizer = Wx::BoxSizer->new(wxVERTICAL);
    my @cb = map{Wx::CheckBox->new($po, -1, 'Haken '. $_)} 1..4;
    $box->Add($_, @std) for @cb;
    
    my $osizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $osizer->Add($box, @std);
    $osizer->Add($rsizer, @std);
    $po->SetSizer($osizer);
    
    my $pu = Wx::Panel->new($mf, -1);
    Wx::RadioButton->new($pu, -1, '22', [10, 10]);
    Wx::RadioButton->new($pu, -1, '43', [10, 40]);
    
    my $panelsizer = Wx::BoxSizer->new(wxVERTICAL);
    $panelsizer->Add($po, 1, wxGROW, 0);
    $panelsizer->Add($pu, 1, wxGROW, 0);
    
    $mf->SetSizer($panelsizer);
    $mf->Show(1);
    
    $pu->SetFocus();
    $app[0]->SetTopWindow($mf);
    
    
    return 1;
}



package main;
flaechen->new->MainLoop;