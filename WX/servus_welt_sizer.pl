#!/usr/bin/perl -w
use strict;


package ServusWelt;
use Wx qw/ :everything /;
use base qw (Wx::App);
use Wx::Event qw(:everything);
use WX::wx_gridtest;
use Wx::AUI;

sub OnInit{
    my @app = @_;
    
    my $mf = Wx::Frame->new(
        undef,
        -1,
        'Mein erstes Programm',
        [-1, -1],
        [1200, 960],
    );
#    $mf->SetWindowStyle(
#        $mf->GetWindowStyleFlag()
#        ^&Wx::wxRESIZE_BORDER
#    );
    
   # $mf->ToggleWindowStyle(
   #     &Wx::wxRESIZE_BORDER  #Lässt Fenstergröße starr
   # );

    my @std = (1, wxEXPAND, 2);
#linkes panel
    my $pl = Wx::Panel->new($mf, -1);
    
    my $box_l = Wx::StaticBoxSizer->new(
                                      Wx::StaticBox->new($pl, -1, 'Box 1'),
                                      wxVERTICAL);
    
    my $title_b = Wx::Button        ->new($pl, -1, 'Titel Ändern',);
    my $spring_weg_b = Wx::Button   ->new($pl, -1, 'Spring weg',);
    my $farbe_b = Wx::Button        ->new($pl, -1, 'Farbe wählen',);
    my $password_b = Wx::Button     ->new($pl, -1, 'Passwort eingeben',);
    
    my @std2 = (1, wxGROW, 5);
    $box_l->Add($title_b, @std2);
    $box_l->Add($spring_weg_b, @std2);
    $box_l->Add($farbe_b, @std2);
    $box_l->Add($password_b, @std2);
    
    my $pl_sizer = Wx::BoxSizer->new(wxVERTICAL);
    $pl_sizer->Add($box_l, @std);
    $pl->SetSizer($pl_sizer);
    
    Wx::Event::EVT_BUTTON($mf, $title_b,        sub{$mf->SetTitle('geändert')});
    Wx::Event::EVT_BUTTON($mf, $spring_weg_b,   \&spring_weg);
    Wx::Event::EVT_BUTTON($mf, $farbe_b,        \&farbe_waehlen);
    Wx::Event::EVT_BUTTON($mf, $password_b,     \&pw_waehlen);
    
# rechtes Panel oben
    
    my $pro = Wx::Panel->new($mf, -1);
    
    my $box_r = Wx::StaticBoxSizer->new(
                                      Wx::StaticBox->new($pro, -1, 'Box 2'),
                                      wxHORIZONTAL);
    
    my $singlejoice_b = Wx::Button  ->new($pro, -1, 'Einzelwahl',);
    my $multijoice_b = Wx::Button   ->new($pro, -1, 'Mehrfachwahl',);
    my $filejoice_b = Wx::Button    ->new($pro, -1, 'Dateiauswahl',);
    my $ende_b = Wx::Button         ->new($pro, -1, 'beenden',);
    
    
    $box_r->Add($singlejoice_b, @std);
    $box_r->Add($multijoice_b, @std);
    $box_r->Add($filejoice_b, @std);
    $box_r->Add($ende_b, @std);
    
    my $pro_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $pro_sizer->Add($box_r, @std);
    $pro->SetSizer($pro_sizer);
    
    Wx::Event::EVT_BUTTON($mf, $singlejoice_b,  \&einzelauswahl);
    Wx::Event::EVT_BUTTON($mf, $multijoice_b,   \&multiauswahl);
    Wx::Event::EVT_BUTTON($mf, $filejoice_b,    \&dateiauswahl);
    Wx::Event::EVT_BUTTON($mf, $ende_b,         \&beenden);
    
 # rechtes Panel unten 
    my $pru = Wx::Panel->new($mf, -1);
    
    my $nb = Wx::AuiNotebook->new($pru, -1, [-1, -1], [800, 640], 
                                  wxAUI_NB_TAB_MOVE
                                  | wxAUI_NB_CLOSE_BUTTON);
    my $sp1 = Wx::ScrolledWindow->new($nb, -1, [-1,-1], [800, 640]);
    my $sp2 = Wx::ScrolledWindow->new($nb, -1);
    my $sp3 = Wx::ScrolledWindow->new($nb, -1);
    
    #$sp1->SetScrollbars(10, 5, 40, 80, 0, 1);
    #$sp2->SetScrollbars(10, 5, 20, 40, 0, 1);
    #$sp3->SetScrollbars(10, 5, 20, 40, 0, 1);
    
    $nb->AddPage($sp1, 'Subpanel 1');
    $nb->AddPage($sp2, 'Subpanel 2');
    $nb->AddPage($sp3, 'Subpanel 3');
    
    WX::wx_gridtest::insert_grid($sp1);
    
    my $pru_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $pru_sizer->Add($nb, 1, wxEXPAND, 10);
    $pru->SetSizer($pru_sizer);
    
    
#rechte Seite    
    my $pr_sizer = Wx::BoxSizer->new(wxVERTICAL);
    $pr_sizer->Add($pro, 1, wxEXPAND, 10);
    $pr_sizer->Add($pru, 9, wxEXPAND, 10);


 #gesamt   
    my $mainsizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $mainsizer->Add($pl, 0, wxGROW, 0);
    $mainsizer->Add($pr_sizer, 1, wxGROW, 0);
    
    $mf->SetSizer($mainsizer);
    $mf->Show(1);
    
    $app[0]->SetTopWindow($mf);
    
    return 1;
}

sub spring_weg{
    my $mf = shift;
    
    my $screen = Wx::GetDisplaySize();
    my ($x_size, $y_size) = $mf->GetSizeWH();
    my $x_pos = int rand $screen->GetWidth - $x_size;
    my $y_pos =int rand $screen->GetHeight - $y_size;
    $mf->SetSize(
        $x_pos, $y_pos, $x_size, $y_size
    )
}

sub titel_aendern{
    my ($mf, $knopf) = @_;
    
    $mf->SetTitle('geändert');
    my $dummy;
    
}

sub farbe_waehlen{
    my ($mf, $knopf) = @_;
    
    my $colour = Wx::GetColourFromUser($mf);
    
    print "$$colour\n";
}

sub pw_waehlen{
    my ($mf, $knopf) = @_;
    
    my $pw = Wx::GetPasswordFromUser('Passwort eingeben', -1, '12345678');
    
    print "$pw\n";
}

sub einzelauswahl{
    my ($mf, $knopf) = @_;
    
    my $sj = Wx::GetSingleChoice('Bin ich gut?',
                                 'Auswahl',
                                 ['sehr gut', 'mittelmäßig', 'bockschlecht']
                                 );
    print $sj;
    
}

sub multiauswahl{
    my ($mf, $knopf) = @_;
    
    my @sj = Wx::GetMultipleChoices('Was findest Du gut?',
                                 'Geschmacksache!',
                                 ['6 Bier', '8 Schnaps', '4 Minaeralwasser']
                                 );
    map {print $_,"\n"} @sj;
    
}

sub dateiauswahl{
    my ($mf, $knopf) = @_;
    
    my $datei = Wx::FileSelector (
        'Datei auswählen',
        '.',
        '',
        '',
        "*.pdf",
        1,
    );
    
    print "$datei\n";
    
}

sub beenden{
    my ($mf, $knopf) = @_;

    my $answer = Wx::MessageBox('Quit_program?',
                                'Confirm',
                                2,
                              );
    
    $mf->Close() if ($answer == 2)
}

package main;
ServusWelt->new->MainLoop;