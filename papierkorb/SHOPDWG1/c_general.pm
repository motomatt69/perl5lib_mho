package PPEEMS::SHOPDWG1::c_general;
use strict;
use PPEEMS::SHOPDWG1::m_b3d_imp;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub teilzngs_holen{
    my ($self) = @_;
    
    $self->get_teilzngs();
    #$self->printtrace("Teilzeichnungen eingelesen\n");
}

sub ascii_lists{
    my ($self) = @_;
    
    $self->import_ascii_lists();
#    $self->ascii_lists2db();
}

sub read_teilzng{
    my ($self, $tzps) = @_;
    
    $self->tzps($tzps);
    $self->set_teilzng_paths();
    
    $self->printtrace("Teilzeichnungen eingelesen\n");
    
}

sub ftp_liste{
    my ($self) = @_;
    
    my $konst = 'FSP';
    my $dat = '2010-06-10';
    
    $self->konstrukteur($konst);
    $self->datum($dat);
    
    $self->daten_fuer_ftpliste();
    $self->pfad_fuer_ftp_liste();
    $self->excel_liste_ausschreiben();
    
    $self->printtrace("FTP-Liste erstellt\n");
}
  
1;