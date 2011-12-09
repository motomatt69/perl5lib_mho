package PPEEMS::DWG::APB::apb_mvc;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use PPEEMS::DWG::APB::view;
use PPEEMS::DWG::APB::c_apbdoku;
use PPEEMS::DWG::APB::m_apb_db;
use PPEEMS::DWG::APB::m_apb_hp_bmf;
use PPEEMS::DWG::DB::m_dwg_db;

has 'htzngs' => (isa => 'ArrayRef',  is => 'rw', required => 0);

sub _mvcitems{
   
    return {
        view                => {
            view1           => {
                class       => 'PPEEMS::DWG::APB::view',
                defines     => {
                },
                strategies  => {
                }
            },
        },
        
        controler           => {
            c_apb           => {
                class       => 'PPEEMS::DWG::APB::c_apbdoku',
                defines     => {'+APB_DB'     => [qw/printtrace
                                                  read_htzngs get_htzngs
                                                  read_htzngdata get_zdata
                                                  check_server
                                /],
                                '+DWG_DB'     => [qw/printtrace
                                                  zdata
                                                  apbposakt
                                                  read_header_and_headertextvars
                                                  get_hdtxtvars get_hdfile
                                                  get_titlestr
                                /],
                                '+APB_HP_BMF' => [qw/printtrace
                                                  htzng apbposakt
                                                  hdfile hdtxtvars
                                                  tmppath cube
                                                  get_apbformat
                                                  nest_bmf
                                /],
                                
                },
                strategies  => {'APB_DB'     => 'm_apb_db',
                                'DWG_DB'     => 'm_dwg_db',
                                'APB_HP_BMF' => 'm_apb_hp_bmf',
                },
            },
        },
        
        model               => {
            m_apb_db        => {
                class       => 'PPEEMS::DWG::APB::m_apb_db',
                observers   => [qw/view1/]
            },
            m_dwg_db        => {
                class       => 'PPEEMS::DWG::DB::m_dwg_db',
                observers   => [qw/view1/]
            },
            m_apb_hp_bmf    => {
                class       => 'PPEEMS::DWG::APB::m_apb_hp_bmf',
                observers   => [qw/view1/]
            },
        },
        error => {
            F1 => [
                'Haupteil BMF zu groß', "Fehler: %s", 'view1'
            ],
        }
    };
}

sub init{
    my ($self) = @_;
    
    my $m_apb_hp_bmf = $self->model('m_apb_hp_bmf');
    my $m_dwg_db = $self->model('m_dwg_db');
    $m_apb_hp_bmf->setStrategy('DWGDB' => $m_dwg_db);
    
    $self->SUPER::init();
    my $view = $self->view('view1');
    $view->{exit_b}->waitVisibility();
    $view->{exit_b}->update();
    $view->{exit_b}->idletasks();
    sleep 1;
    
    my $c = $self->controler('c_apb');
    $c->start();
    

}


1;
