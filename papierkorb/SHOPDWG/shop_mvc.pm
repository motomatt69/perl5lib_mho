package PPEEMS::SHOPDWG::shop_mvc;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use PPEEMS::SHOPDWG::view;
#use PPEEMS::SHOPDWG::c_general;
#use PPEEMS::SHOPDWG::c_apb_hp_bmf;
use PPEEMS::SHOPDWG::c_shopdoku;
use PPEEMS::SHOPDWG::m_shop_pdf;
#use PPEEMS::SHOPDWG::c_bpscsv;
#use PPEEMS::SHOPDWG::m_db;
#use PPEEMS::SHOPDWG::m_ftpliste;
#use PPEEMS::SHOPDWG::m_b3d_imp;
use PPEEMS::STL::m_dstv_stl;
use PPEEMS::SHOPDWG::m_shop_db;
use PPEEMS::STL::m_swd_stl;
#use PPEEMS::STL::m_apb_stl;

has 'pfad' => (isa => 'Str',  is => 'rw', required => 0);


sub _mvcitems{
   
    return {
        view                => {
            view1           => {
                class       => 'PPEEMS::SHOPDWG::view',
                defines     => {
                },
                strategies  => {
                }
            },
        },
        
        controler           => {
            #c_apb           => {
            #    class       => 'PPEEMS::SHOPDWG::c_apb_hp_bmf',
            #    defines     => {m_db    => [qw/printtrace get_tzdata zdata
            #                                apbpos_act get_header_headertexts
            #                                hdfile hdtxtvars teilzngs
            #                                get_teilzng_paths set_sizes
            #                                get_single_template
            #                                get_frame_sizes
            #                                set_apbzng2apbpos
            #                                set_eintrag_teilzeichnung_erstellt
            #                                /],
            #    },
            #    strategies  => {m_db => 'm_db',
            #    },
            #},
            #c_shop          => {
            #    class       => 'PPEEMS::SHOPDWG::c_shop_pdf',
            #    defines     => {m_db    => [qw/printtrace get_wzdata zdata
            #                                get_header_headertexts hdfile
            #                                hdtxtvars
            #                                teilzngs get_teilzng_paths
            #                                get_single_template
            #                                get_frame_sizes
            #                                get_apbposs2b3dpos
            #                                /],
            #    },
            #    strategies  => {m_db => 'm_db',
            #    },
            #},
            c_shop          => {
                class       => 'PPEEMS::SHOPDWG::c_shopdoku',
                defines     => {'+DSTV'    => [qw/printtrace
                                            convert_bpscsv dstvls hposls
                                            /],
                                '+SHOP_DB' => [qw/printtrace
                                            check_pdf_available  get_selteilzngpaths
                                            get_wzdata
                                            /],
                                '+SHOP_PDF'=> [qw/printtrace
                                            pdf_creation wzdata
                                            /],
                                '+SWD'     => [qw/printtrace
                                            convert_dstvls dstvls save_swdls
                                            /],
                               # '+APB'     => [qw/printtrace
                               #             split_dstvls dstvls save_apbls
                               #             /],
                },
                strategies  => {'DSTV'    => 'm_dstv',
                                'SHOP_DB' => 'm_shop_db',
                                'SHOP_PDF'=> 'm_shop_pdf',
                                'SWD'     => 'm_swd',
                               # 'APB'  => 'm_apb',
                },
            },
            
        },
        
        model               => {
            #m_db            => {
            #    class       => 'PPEEMS::SHOPDWG::m_db',
            #    observers   => [qw/view1/]
            #},
            #m_ftpliste      => {
            #    class       => 'PPEEMS::SHOPDWG::m_ftpliste',
            #    observers   => [qw/view1/]
            #},
            #m_b3d_imp       => {
            #    class       => 'PPEEMS::SHOPDWG::m_b3d_imp',
            #    observers   => [qw/view1/]
            #},
            m_dstv          => {
                class       => 'PPEEMS::STL::m_dstv_stl',
                observers   => [qw/view1/]
            },
            m_shop_db          => {
                class       => 'PPEEMS::SHOPDWG::m_shop_db',
                observers   => [qw/view1/]
            },
            m_shop_pdf      => {
                class       => 'PPEEMS::SHOPDWG::m_shop_pdf',
                observers   => [qw/view1/]
            },
            m_swd           => {
                class       => 'PPEEMS::STL::m_swd_stl',
                observers   => [qw/view1/]
            },
            #m_apb           => {
            #    class       => 'PPEEMS::STL::m_apb_stl',
            #    observers   => [qw/view1/]
            #},
        },
        
        error => {
            F1 => [
                'Zeichnung nicht in DB', "F: %s", 'view1'
            ],
        }
    };
}

sub init{
    my ($self) = @_;
    
    $self->SUPER::init();
    my $view = $self->view('view1');
    $view->{path_lb}->configure(-text => $self->pfad());
    $view->{exit_b}->waitVisibility();
    $view->{exit_b}->update();
    $view->{exit_b}->idletasks();
    print "Hallo 1\n";
    sleep 1;
    print "Hallo\n";
    my $c = $self->controler('c_shop');
    my $p = $self->{pfad};
    $c->start($p);
    
}

1;
