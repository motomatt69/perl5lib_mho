package STATIK::c_statik;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub read_last_settings{
    my ($self) = @_;
    
    $self->M_STATIK_read_last_settings();
}

sub canv2pdf{
    my ($self, $canv, $show_or_print) = @_;
    
    $self->M_STATIK_show_or_print($show_or_print);
    $self->M_STATIK_canv($canv);
    $self->M_STATIK_canv2pdf();
}

sub ral_m2v{
    my ($self) = @_;
    
    $self->M_RAL_read_ral_data();
}

sub ral_act{
    my ($self, $progact, $hexastr) = @_;
    
    $self->M_STATIK_write_ral_act($progact, $hexastr)
}

sub write_settings{
    my ($self, $progact, $e_vals) = @_;
    
    $self->M_STATIK_write_settings($progact, $e_vals)
}
1;