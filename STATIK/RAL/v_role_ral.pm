package STATIK::RAL::v_role_ral;
use strict;

use Moose::Role;

use Tk::HList;
use Tk::Utils::Grid;

has ral => (isa => 'ArrayRef', is => 'rw', auto_deref => 1);

sub _raise_ral_hlist{
    my ($self) = @_;
    
    my $mw = $self->widget($self->mvcname());
    
    my $dia = $mw->DialogBox(-title => 'RAL _ Auswahl',
                             -buttons => ['Ok', 'Cancel'],
                             -cancel_button => 'Cancel');
    $dia->geometry("300x300");
    
    my $hlb = $dia->Scrolled('HList',
                            -scrollbars => 'se',
                            -columns => 3,
                            -height => 192,
                            -width => 193,
                            -header => 1,
                            -selectmode => "single",
                            )->pack(-expand => 1,
                                    -ipadx => 2,
                                    -ipady => 2);
                             
    $hlb->headerCreate(0, -text => 'RAL-Nr');
    $hlb->headerCreate(1, -text => 'Bezeichnung');
    $hlb->headerCreate(2, -text => 'Vorschau');
    
    $self->C_STATIK_ral_m2v();
    my @rals = $self->ral();
    
    foreach  my $ral (@rals) {
        $hlb->add($ral->[0]);
        $hlb->itemCreate($ral->[0], 0, -text => $ral->[0]);
        $hlb->itemCreate($ral->[0], 1, -text => $ral->[1]);
        $hlb->itemCreate($ral->[0], 2, -text => $ral->[2]);
        
        my $style = $hlb->ItemStyle('text',
                                                -background => $ral->[2],
                                                -foreground => $ral->[2]);
        
        $hlb->itemConfigure("$ral->[0]", 2, -style => $style);
    }
    
    $hlb->bind('<ButtonRelease-1>',
                           sub{$self->_ral_act($hlb)});
        
    my $bto = $dia->Show();
}

sub obs_ral_data{
    my ($self, $not) = @_;
    
    my $ral = $not->ral_data();
    $self->ral($ral);
}

sub _ral_act{
    my ($self, $hlb) = @_;
    
    my $entry = $hlb->selectionGet();
    my $hexastr = $hlb->itemCget($entry,2,"text");
    
    my $nbook = $self->Widget('NBook');
    my $progact = $nbook->info("active");
    $self->C_STATIK_ral_act($progact, $hexastr);
}


1;
