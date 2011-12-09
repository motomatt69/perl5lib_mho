package PPEEMS::SHOPDWG::c_shopdoku;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub start{
    my ($self, $p) = @_;
    
    $self->DSTV_convert_bpscsv($p);
    
    #Überprüfen ob alle PDF Zeichnungen zur Stückliste vorhanden
    my $hposlsref = $self->DSTV_hposls;
    $self->SHOP_DB_check_pdf_available($hposlsref);
    
    #SWD Liste ausschreiben
    #$self->_swd_liste();
    
    #Werkstattzeichnungen erstellen
    my $selteilzngpaths = $self->SHOP_DB_get_selteilzngpaths();
    $self->SHOP_PDF_pdf_creation($selteilzngpaths);
    
    my $dummy;
}

sub _swd_liste{
    my ($self) = @_;
    
    my $dstv_ls = $self->DSTV_dstvls();
    
    $self->SWD_dstvls($dstv_ls);
    $self->SWD_convert_dstvls;
    $self->SWD_save_swdls;
}
    
sub bpscsv2apb_liste{
    my ($self, $p) = @_;
    
    $self->DSTV_convert_bpscsv($p);
    my $dstv_ls = $self->DSTV_dstvls();
    
    $self->APB_dstvls($dstv_ls);
    $self->APB_split_dstvls;
    $self->APB_save_apbls;
}

1;
