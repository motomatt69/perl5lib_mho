package STATIK::CROSEC::mvc_crosec;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use STATIK::CROSEC::v_crosec;
use STATIK::CROSEC::c_crosec;
use STATIK::c_statik;
use STATIK::RAL::m_ral;
use STATIK::CROSEC::m_crosec;
use STATIK::m_statik;

has e_vals => (isa => 'HashRef', is => 'rw'); 

sub _mvcitems{
   
    return {
        view                => {
            Application           => {
                class       => 'STATIK::CROSEC::v_crosec',
                defines     => {
                                '+C_CROSEC' => [qw/anzeige_refresh
                                                   /],
                                '+C_STATIK' => [qw/canv2pdf
                                                   /],
                },
                strategies  => {'C_CROSEC'    => 'c_crosec',
                                'C_STATIK'    => 'c_statik',
                }
            },
        },
        
        controler           => {
            c_crosec       => {
                class       => 'STATIK::CROSEC::c_crosec',
                defines     => {'+M_CRO'  => [qw/printtrace
                                                reihe size    
                                                sketch_size
                                                validate val_res
                                                calc_cs_canv_data
                                                /],
                                '+RAL'    => [qw/read_ral_data
                                                /],
                },
                
                strategies  => {'M_CRO' => 'm_crosec',
                                'RAL'   => 'm_ral',
                },
            },
            c_statik       => {
                class       => 'STATIK::c_statik',
                defines     => {'+M_STATIK' => [qw/show_or_print
                                                  canv canv2pdf
                                                /],
                },
                
                strategies  => {'M_STATIK' => 'm_statik'
                },
            },
        },
        
        model               => {
            m_ral           => {
                class       => 'STATIK::RAL::m_ral',
                observers   => [qw/Application/]
            },
            m_crosec        => {
                class       => 'STATIK::CROSEC::m_crosec',
                observers   => [qw/Application/]
            },
            m_statik        => {
                class       => 'STATIK::m_statik',
                observers   => [qw/Application/]
            },
        },
        
        error => {
            F1 => [
                'Zeichnung nicht in DB', "F: %s", 'Application'
            ],
        }
    };
}

sub init{
    my ($self) = @_;
    
    my $v = $self->view('Application');
    $v->e_vals($self->e_vals);
    
    $self->SUPER::init();
}

1;
