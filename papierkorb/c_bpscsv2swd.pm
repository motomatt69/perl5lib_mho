package PPEEMS::SHOPDWG::c_bpscsv2swd;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub bpscsv2swd_liste{
    my ($self, $p) = @_;
    
    $self->DSTV_convert_bpscsv($p);
    my $dstv_ls = $self->DSTV_dstvls();
    
    $self->SWD_dstvls($dstv_ls);
    $self->SWD_convert_dstvls;
    $self->SWD_save_swdls;
    
    my $dummy

}
    


1;