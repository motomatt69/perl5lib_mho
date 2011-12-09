#!/usr/bin/perl -w
use strict;


package ServusWelt;
use Wx qw/ :everything /;
use base qw (Wx::App);
use Wx::Event qw(EVT_BUTTON);

sub OnInit{
    my @app = @_;
    
    my $frame = Wx::Frame->new(
        undef,
        -1,
        'Mein erstes Programm',
        [-1, -1],
        [250, 200],
    );
#    $frame->SetWindowStyle(
#        $frame->GetWindowStyleFlag()
#        ^&Wx::wxRESIZE_BORDER
#    );
    
   # $frame->ToggleWindowStyle(
   #     &Wx::wxRESIZE_BORDER  #Lässt Fenstergröße starr
   # );
    
    my $panel = Wx::Panel->new($frame, -1);
    
    my $title_b = Wx::Button->new($panel,
                                -1,
                                'Titel Ändern',
             #                   [65, 20],
    );
    
    my $spring_weg_b = Wx::Button->new($panel,
                                -1,
                                'Servus Welt',
                           #     [65, 20],
    );
    
    my $farbe_b = Wx::Button->new($panel,
                                 -1,
                                 'Farbe wählen',
                           #      [65, 40 ],
    );
    
    my $password_b = Wx::Button->new($panel,
                                 -1,
                                 'Passwort eingeben',
                               #  [65, 60 ],
    );
    
     my $singlejoice_b = Wx::Button->new($panel,
                                 -1,
                                 'Einzelwahl',
                              #   [65, 80 ],
    );
     
    my $multijoice_b = Wx::Button->new($panel,
                                 -1,
                                 'Mehrfachwahl',
                               #  [65, 100 ],
    );
    
    my $filejoice_b = Wx::Button->new($panel,
                                 -1,
                                 'Dateiauswahl',
                              #   [65, 120 ],
    );
    
    my $ende_b = Wx::Button->new($panel,
                                 -1,
                                 'beenden',
                              #   [65, 140 ],
    );
    
    my $sizer = Wx::BoxSizer->new(wxVERTICAL);
    $sizer->Add($title_b,       1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($spring_weg_b,  1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($farbe_b,       1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($password_b,    1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($singlejoice_b, 1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($multijoice_b,  1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($filejoice_b,   1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    $sizer->Add($ende_b,        1, wxALIGN_CENTER | wxALL | wxEXPAND, 1);
    
    #EVT_BUTTON($knopf, $knopf, sub{
    #    $frame->SetTitle('geändert')
    #});
    
    Wx::Event::EVT_BUTTON($frame, $title_b, sub{$frame->SetTitle('geändert')});
    
    Wx::Event::EVT_BUTTON($frame, $spring_weg_b, \&spring_weg);
    
    Wx::Event::EVT_BUTTON($frame, $farbe_b, \&farbe_waehlen);
    
    Wx::Event::EVT_BUTTON($frame, $password_b, \&pw_waehlen);
    
    Wx::Event::EVT_BUTTON($frame, $singlejoice_b, \&einzelauswahl);
    
    Wx::Event::EVT_BUTTON($frame, $multijoice_b, \&multiauswahl);
    
    Wx::Event::EVT_BUTTON($frame, $filejoice_b, \&dateiauswahl);
    
    Wx::Event::EVT_BUTTON($frame, $ende_b, \&beenden);
    
    $panel->SetSizer($sizer);
    $frame->Show(1);
    $app[0]->SetTopWindow($frame);
    
    1;
}

sub spring_weg{
    my $frame = shift;
    
    my $screen = Wx::GetDisplaySize();
    my ($x_size, $y_size) = $frame->GetSizeWH();
    my $x_pos = int rand $screen->GetWidth - $x_size;
    my $y_pos =int rand $screen->GetHeight - $y_size;
    $frame->SetSize(
        $x_pos, $y_pos, $x_size, $y_size
    )
}

sub titel_aendern{
    my ($frame, $knopf) = @_;
    
    $frame->SetTitle('geändert');
    my $dummy;
    
}

sub farbe_waehlen{
    my ($frame, $knopf) = @_;
    
    my $colour = Wx::GetColourFromUser($frame);
    
    print "$$colour\n";
}

sub pw_waehlen{
    my ($frame, $knopf) = @_;
    
    my $pw = Wx::GetPasswordFromUser('Passwort eingeben', -1, '12345678');
    
    print "$pw\n";
}

sub einzelauswahl{
    my ($frame, $knopf) = @_;
    
    my $sj = Wx::GetSingleChoice('Bin ich gut?',
                                 'Auswahl',
                                 ['sehr gut', 'mittelmäßig', 'bockschlecht']
                                 );
    print $sj;
    
}

sub multiauswahl{
    my ($frame, $knopf) = @_;
    
    my @sj = Wx::GetMultipleChoices('Was findest Du gut?',
                                 'Geschmacksache!',
                                 ['6 Bier', '8 Schnaps', '4 Minaeralwasser']
                                 );
    map {print $_,"\n"} @sj;
    
}

sub dateiauswahl{
    my ($frame, $knopf) = @_;
    
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
    my ($frame, $knopf) = @_;

    my $answer = Wx::MessageBox('Quit_program?',
                                'Confirm',
                                2,
                              );
    
    $frame->Close() if ($answer == 2)
}

package main;
ServusWelt->new->MainLoop;