package PROFILE::CROSEC::controler;
use strict;

sub new{
    my ($class, $view, $m_cro_hws, $m_cro_qws, $m_cro_tws, $m_cro_iprofil, $m_ral, 
        $m_sketch_size, $m_batch, $m_csv2boc3d ) = @_;
    
    my $self = bless{}, $class;
    $self->{view} = $view;
    $self->{m_cro_hws} = $m_cro_hws;
    $self->{m_cro_qws} = $m_cro_qws;
    $self->{m_cro_tws} = $m_cro_tws;
    $self->{m_cro_iprofil} = $m_cro_iprofil;
    $self->{m_ral} = $m_ral;
    $self->{m_sketch_size} = $m_sketch_size;
    $self->{m_batch} = $m_batch;
    $self->{m_csv2boc3d} = $m_csv2boc3d; 
    
    return $self;
}

 
sub message{
   my ($self, $message) = @_;
    
   if ($message eq 'ende') {$self->view_ende()}
   if ($message eq 'need_ral') {$self->ral_m2v()}
   if ($message eq 'show') {$self->datenuebertrag()}
   if ($message eq 'batch') {$self->batch()}
   if ($message eq 'exp_val') {$self->csv2boc3d()}
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
       
    if ($reihe eq 'HWS' or $reihe eq 'QWS' or $reihe eq 'TWS'){
        my $m_cro = 'm_cro_'. lc $reihe;
        my $size = $self->{view}->get_size();
        $self->{$m_cro}->set_size($size);
        
        my $h = $self->{$m_cro}->get_h();
        my $b = $self->{$m_cro}->get_b();
        $self->{m_sketch_size}->set_h($h);
        $self->{m_sketch_size}->set_b($b);
        
        $self->validresult_and_show();   
    }
    elsif ($reihe eq 'HEA' or $reihe eq 'HEB'){
        $self->{m_cro_iprofil}->set_reihe($reihe);
        my $nh = $self->{view}->get_nh();
        $self->{m_cro_iprofil}->set_nh($nh);
        $self->{m_cro_iprofil}->set_profgeo();
        
        $self->iprofil_validresult_and_show(); 
    }    
}

sub validresult_and_show{    
    my ($self) = @_;
    
    my $reihe = $self->{view}->get_reihe();
    my $m_cro = 'm_cro_'. lc $reihe;
    
    $self->{$m_cro}->set_validate();
    my $val_res = $self->{$m_cro}->get_val_res();
    
    if ($val_res->[0] eq 'notvalid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
    }
    elsif($val_res->[0] eq 'valid') {
        $self->{view}->set_val_res($val_res);
        $self->{view}->set_entrys_aktu();
        
        my %sketchvals = $self->{m_sketch_size}->get_sketchvals();
                
        $self->{$m_cro}->set_sketchvals(%sketchvals);
        $self->{$m_cro}->set_cs_canv_data();
        $self->{view}->set_canv_aktu();
    }
}
    
sub iprofil_validresult_and_show{
    my ($self) = @_;
    
    $self->{m_cro_iprofil}->set_validate();
    my $val_res = $self->{m_cro_iprofil}->get_val_res();
    
    $self->{view}->set_val_res($val_res);
    $self->{view}->set_entrys_aktu();
        
    my $h = $self->{m_cro_iprofil}->get_h();
    my $b = $self->{m_cro_iprofil}->get_b();
    $self->{m_sketch_size}->set_h($h);
    $self->{m_sketch_size}->set_b($b);
    
    my %sketchvals = $self->{m_sketch_size}->get_sketchvals();
    $self->{m_cro_iprofil}->set_sketchvals(%sketchvals);
    $self->{m_cro_iprofil}->set_cs_canv_data();
    $self->{view}->set_canv_aktu();
}    

sub batch{
    my ($self) = @_;
    
    my $reihe = $self->{view}->get_reihe();
    $self->{m_batch}->set_reihe($reihe);
    my %vals = $self->{m_batch}->get_values();
    
    for my $key (keys %vals){
        my $size = $vals{$key};
    
        $self->{view}->set_h($size->[0]);
        $self->{view}->set_b($size->[1]);
        $self->{view}->set_ts($size->[2]);
        $self->{view}->set_tg($size->[3]);
        $self->{view}->set_aw($size->[4]);
        
        $self->{view}->set_size();
        
        print $key,"\n";        
        $self->datenuebertrag();
        
        $self->csv2boc3d();
        $self->{view}->do_pdf_save();
    }
}

sub csv2boc3d{
    my ($self) = @_;
    
    my $vals_ref = $self->{view}->get_vals();
    $self->{m_csv2boc3d}->set_vals($vals_ref);
    $self->{m_csv2boc3d}->set_csv();
}
1;