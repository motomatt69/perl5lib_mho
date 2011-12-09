package STATIK::mvc_statik;
use strict;
use warnings;
use Sys::Hostname;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use STATIK::v_statik;
use STATIK::c_statik;
use STATIK::m_statik;
use STATIK::RAL::m_ral;

sub _mvcitems{
   
    return {
        view                => {
            Application           => {
                class       => 'STATIK::v_statik',
                defines     => {'+C_STATIK' => [qw/read_last_settings
                                                    canv2pdf
                                                   ral_m2v ral_act
                                                   write_settings/],
                },
                strategies  => {'C_STATIK'    => 'c_statik',
                }
            },
        },
        
        controler           => {
            c_statik       => {
                class       => 'STATIK::c_statik',
                defines     => {'+M_STATIK' => [qw/read_last_settings
                                                  show_or_print
                                                  canv canv2pdf
                                                  write_ral_act
                                                  write_settings
                                                /],
                                '+M_RAL'    =>  [qw/read_ral_data
                                                 /],
                },
                
                strategies  => {'M_STATIK' => 'm_statik',
                                'M_RAL'    => 'm_ral'
                },
            },
        },
        
        model               => {
            m_statik        => {
                class       => 'STATIK::m_statik',
                observers   => [qw/Application/]
            },
            m_ral           => {
                class       => 'STATIK::RAL::m_ral',
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

    my $m = $self->model('m_statik');
    my $user = hostname;
    $m->user($user);
    
    $self->SUPER::init();
}

1;
