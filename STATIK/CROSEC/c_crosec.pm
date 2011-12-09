package STATIK::CROSEC::c_crosec;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub anzeige_refresh{
    my ($self, $reihe, $size_ref, $sketch_size) = @_;
    
    $self->M_CRO_reihe($reihe);
    $self->M_CRO_size($size_ref);
    $self->M_CRO_sketch_size($sketch_size); 
    
    $self->M_CRO_validate();
    my ($val_res) = $self->M_CRO_val_res();
    
    if($val_res eq 'valid') {
        $self->M_CRO_calc_cs_canv_data();
        #my %sketchvals = $self->{m_sketch_size}->get_sketchvals();
                
        #$self->{$m_cro}->set_sketchvals(%sketchvals);
       # 
        #$self->{view}->set_canv_aktu();
    }
    #if ($reihe eq 'HWS' or $reihe eq 'QWS' or $reihe eq 'TWS'){
    #    my $str = '$self->'.$reihe.'_validate()';
    #    eval ($str);
    #    
    #    my $m_cro = 'm_cro_'. lc $reihe;
    #    my $size = $self->{view}->get_size();
    #    $self->{$m_cro}->set_size($size);
    #    
    #    my $h = $self->{$m_cro}->get_h();
    #    my $b = $self->{$m_cro}->get_b();
    #    $self->{m_sketch_size}->set_h($h);
    #    $self->{m_sketch_size}->set_b($b);
    #    
    #    $self->validresult_and_show();
    #}
    #elsif ($reihe eq 'HEA' or $reihe eq 'HEB'){
    #    $self->{m_cro_iprofil}->set_reihe($reihe);
    #    my $nh = $self->{view}->get_nh();
    #    $self->{m_cro_iprofil}->set_nh($nh);
    #    $self->{m_cro_iprofil}->set_profgeo();
    #    
    #    $self->iprofil_validresult_and_show(); 
    #}    
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