package PROFILE::CROSEC::controler;
use strict;

sub new{
    my ($class, $view, $m_cro_hws, $m_ral, $m_reihe, $m_sketch_size) = @_;
    my $self = bless{}, $class;
    $self->{view} = $view;
    $self->{m_cro_hws} = $m_cro_hws;
    $self->{m_ral} = $m_ral;
    $self->{m_reihe} = $m_reihe;
    $self->{m_sketch_size} = $m_sketch_size;
    
    return $self;
}

 
sub message{
   my ($self, $message) = @_;
    
   if ($message eq 'ende') {$self->view_ende()}
   if ($message eq 'need_ral') {$self->ral_m2v()}
   if ($message eq 'show') {$self->datenuebertrag()};
                           # $self->validieren()}
}
 
sub view_ende{ exit};
 
sub ral_m2v{
    my ($self) = @_;
    
    $self->{m_ral}->get_ral_data();
    $self->{view}->set_ral_data($self->{m_ral}->{ral_data});
}

sub datenuebertrag{
    my($self) = @_;
    
    my $reihe = $self->{view}->get_reihe();
    my $sketch_size = $self->{view}->get_sketch_size();
    $self->{m_sketch_size}->set_sketch_size($sketch_size); 
       
    if ($reihe eq 'HWS'){
        my $size = $self->{view}->get_entry_size();
        $self->{m_cro_hws}->set_size($size);
        
        my $h = $self->{m_cro_hws}->get_h();
        my $b = $self->{m_cro_hws}->get_b();
        $self->{m_sketch_size}->set_h($h);
        $self->{m_sketch_size}->set_b($b);
        
        $self->validieren();
    }
    elsif ($reihe ne 'HWS'){
        $self->{m_reihe}->set_reihe($reihe);
        my $nh = $self->{view}->get_nh();
        $self->{m_reihe}->set_nh($nh);
        $self->{m_reihe}->set_profhoehen();        
    
        my $rowvals = $self->{m_reihe}->get_rowvals();
        $self->{view}->set_rowvals($rowvals);
    }
    
 
}

sub validieren{    
    my ($self) = @_;
    
    $self->{m_cro_hws}->set_validate();
    my $val_res = $self->{m_cro_hws}->get_val_res();
    if ($val_res->[0] eq 'notvalid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
    }
    elsif($val_res->[0] eq 'valid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
        
        my %sketchvals = $self->{m_sketch_size}->get_sketchvals();
                
        $self->{m_cro_hws}->set_sketchvals(%sketchvals);
        $self->{m_cro_hws}->set_cs_canv_data();
        $self->{view}->set_canv_aktu();
    }
}
    
    
    
1;