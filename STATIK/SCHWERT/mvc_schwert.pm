package STATIK::SCHWERT::mvc_schwert;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use STATIK::SCHWERT::v_schwert;
use STATIK::SCHWERT::c_schwert;
use STATIK::SCHWERT::m_schwert;


sub _mvcitems{
   
    return {
        view                => {
            Application           => {
                class       => 'STATIK::SCHWERT::v_schwert',
                defines     => {
                                '+C_SCHWERT' => [qw/
                                                   /],
                },
                strategies  => {'C_SCHWERT'    => 'c_schwert',
                }
            },
        },
        
        controler           => {
            c_schwert       => {
                class       => 'STATIK::SCHWERT::c_schwert',
                defines     => {'+M_SCHWERT'  => [qw/printtrace
                                                /],
                },
                
                strategies  => {'M_SCHWERT' => 'm_schwert',
                },
            },
        },
        
        model               => {
            m_schwert        => {
                class       => 'STATIK::SCHWERT::m_schwert',
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
    
    
    $self->SUPER::init();
}

1;
