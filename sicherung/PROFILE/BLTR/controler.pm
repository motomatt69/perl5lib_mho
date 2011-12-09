package PROFILE::BLTR::controler;
use strict;

sub new{
    my ($class, $view, $m_cro, $m_ral) = @_;
    my $self = bless{}, $class;
    $self->{view} = $view;
    $self->{m_cro} = $m_cro;
    $self->{m_ral} = $m_ral;
    
    return $self;
}

 
sub message{
   my ($self, $message) = @_;
    
   if ($message eq 'ende') {$self->view_ende()}
   if ($message eq 'need_ral') {$self->ral_m2v()}
   if ($message eq 'show') {$self->validieren()}
}
 
sub view_ende{ exit};
 
sub ral_m2v{
    my ($self) = @_;
    
    $self->{m_ral}->get_ral_data();
    $self->{view}->set_ral_data($self->{m_ral}->{ral_data});
}
    
sub validieren{    
    my ($self) = @_;
    my $size = $self->{view}->get_entry_size();
    $self->{m_cro}->set_size($size);
    $self->{m_cro}->set_validate();
    my $val_res = $self->{m_cro}->get_val_res();
    if ($val_res->[0] eq 'notvalid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
    }
    elsif($val_res->[0] eq 'valid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
        $self->{m_cro}->set_cs_canv_data();
        $self->{view}->cs_canv_aktu();
    }
}
    
    
    
1;