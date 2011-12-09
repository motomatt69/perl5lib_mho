package PPEEMS::BMF_TABS::bmf_tabs_mvc;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use PPEEMS::BMF_TABS::view;
use PPEEMS::BMF_TABS::c_bmf_tabs;
use PPEEMS::BMF_TABS::m_bmf_tabs;


sub _mvcitems{
   
    return {
        view                => {
            view1           => {
                class       => 'PPEEMS::BMF_TABS::view',
                defines     => {'+C_BMF_TABS'   => [qw/read_block_bgr
                                                    uebersichten_tab
                                                
                                /],
                },
                strategies  => {'C_BMF_TABS'    => 'c_bmf_tabs',
                }
            },
        },
        
        controler           => {
            c_bmf_tabs      => {
                class       => 'PPEEMS::BMF_TABS::c_bmf_tabs',
                defines     => {'+M_BMF_TABS'   => [qw/printtrace
                                                  read_block_bgr
                                                  selbgs read_ueb_data
                                                  create_ueb_bmf
                                /],
                },
                strategies  => {'M_BMF_TABS'     => 'm_bmf_tabs',
        
                },
            },
        },
        
        model               => {
            m_bmf_tabs      => {
                class       => 'PPEEMS::BMF_TABS::m_bmf_tabs',
                observers   => [qw/view1/]
            },
        },
        error => {
            F1 => [
                'Zeichnung nicht in DB', "Fehler: %s", 'view1'
            ],
        }
    };
}

#sub init{
#    my ($self) = @_;
#    
#    $self->SUPER::init();
#    my $view = $self->view('view1');
#    $view->{exit_b}->waitVisibility();
#    $view->{exit_b}->update();
#    $view->{exit_b}->idletasks();
#    sleep 1;
#    
#    my $c = $self->controler('c_apb');
#    $c->start();
#    
#
#}


1;
