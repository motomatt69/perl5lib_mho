use strict;
use warnings;

Handrechner->new->MainLoop;

package Handrechner;
use base qw(Wx::App);
use Wx qw (wxVERTICAL wxHORIZONTAL wxTOP wxLEFT wxGROW wxTE_RIGHT);
use Wx::Event qw( EVT_BUTTON EVT_TEXT_ENTER );
sub OnInit {
    my $frame = Wx::Frame->new( undef, -1, 'Wx Rechner', [-1,-1], [160, 228]);
    my $panel = Wx::Panel->new( $frame, -1);
    my $term  = $panel->{'term'} = Wx::TextCtrl->new( $panel, -1, '', [-1,-1], [-1,-1], wxTE_RIGHT );
    for my $label (0..9,'=','+','-','*','/','.','+/-','<-|', 'C' ) {
        $panel->{button}{$label} = Wx::Button->new( $panel, -1, " $label ", [-1,-1], [25,-1]);         
        EVT_BUTTON($panel, $panel->{button}{$label}, sub {
            $term->AppendText($label);
            Wx::Window::SetFocus($term);         
        } );
    }     
    EVT_BUTTON($panel, $panel->{button}{'+/-'}, sub { } );
    EVT_BUTTON($panel, $panel->{button}{'<-|'}, sub {
        my $pos = $term->GetInsertionPoint;
        $term->Remove($pos-1, $pos);
        Wx::Window::SetFocus($term);     
    } );
    EVT_BUTTON($panel, $panel->{button}{'C'}, sub {
        $term->Clear;
        Wx::Window::SetFocus($term); 
    } );     
    EVT_BUTTON($panel, $panel->{button}{'='}, \&eval_term );
    EVT_TEXT_ENTER($panel, $term, \&eval_term);

    my $h_sizer = Wx::BoxSizer->new(wxVERTICAL);
    my $r0_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r0_sizer->Add( $term,  1, wxLEFT, 5 );
    $r0_sizer->AddSpacer(5);

    my $r1_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r1_sizer->Add( $panel->{button}{'C'},  0, wxLEFT,  5 );
    $r1_sizer->Add($panel->{button}{'<-|'}, 0, wxLEFT,  5 );
    $r1_sizer->Add( $panel->{button}{'='},  1, wxLEFT, 48 );
    $r1_sizer->AddSpacer(5);

    my $r2_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r2_sizer->Add( $panel->{button}{1},  0, wxLEFT, 5 );     
    $r2_sizer->Add( $panel->{button}{2},  0, wxLEFT, 5 );
    $r2_sizer->Add( $panel->{button}{3},  0, wxLEFT, 5 );
    $r2_sizer->Add( $panel->{button}{'+'},0, wxLEFT,25 );

    my $r3_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r3_sizer->Add( $panel->{button}{4},  0, wxLEFT, 5 );     
    $r3_sizer->Add( $panel->{button}{5},  0, wxLEFT, 5 );
    $r3_sizer->Add( $panel->{button}{6},  0, wxLEFT, 5 );
    $r3_sizer->Add( $panel->{button}{'-'},0, wxLEFT,25 );

    my $r4_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r4_sizer->Add( $panel->{button}{7},  0, wxLEFT, 5 );
    $r4_sizer->Add( $panel->{button}{8},  0, wxLEFT, 5 );
    $r4_sizer->Add( $panel->{button}{9},  0, wxLEFT, 5 );
    $r4_sizer->Add( $panel->{button}{'*'},0, wxLEFT,25 );

    my $r5_sizer = Wx::BoxSizer->new(wxHORIZONTAL);
    $r5_sizer->Add( $panel->{button}{'.'}, 0,wxLEFT, 5 );
    $r5_sizer->Add( $panel->{button}{'0'}, 0,wxLEFT, 5 );
    $r5_sizer->Add($panel->{button}{'+/-'},0,wxLEFT, 5 );
    $r5_sizer->Add( $panel->{button}{'/'}, 0,wxLEFT,25 );

    $h_sizer->Add( $r0_sizer,  0, wxTOP|wxGROW,  7 );
    $h_sizer->Add( $r1_sizer,  0, wxTOP|wxGROW, 15 );
    $h_sizer->Add( $r2_sizer,  0, wxTOP, 15 );
    $h_sizer->Add( $r3_sizer,  0, wxTOP,  5 );
    $h_sizer->Add( $r4_sizer,  0, wxTOP,  5 );
    $h_sizer->Add( $r5_sizer,  0, wxTOP, 5 );

    $panel->SetSizer($h_sizer);
    $panel->SetAutoLayout(1);     
    $frame->Show(1); 
}  

sub eval_term {
    my $term = shift->{'term'};
    $term->SetValue( eval($term->GetValue) ) if $term->GetValue;
    $term->SetInsertionPointEnd;
    Wx::Window::SetFocus($term);
}


