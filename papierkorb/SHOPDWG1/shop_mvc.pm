package PPEEMS::SHOPDWG1::shop_mvc;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC'};

use PPEEMS::SHOPDWG1::view;
use PPEEMS::SHOPDWG1::c_general;
use PPEEMS::SHOPDWG1::c_apb_hp_bmf;
use PPEEMS::SHOPDWG1::c_shop_pdf;
use PPEEMS::SHOPDWG1::c_bpscsv;
use PPEEMS::SHOPDWG1::m_db;
use PPEEMS::SHOPDWG1::m_ftpliste;
use PPEEMS::SHOPDWG1::m_b3d_imp;
use PPEEMS::STL::m_dstv_stl;
use PPEEMS::STL::m_swd_stl;
use PPEEMS::STL::m_apb_stl;


sub _mvcitems{
   
    return {
        view                => {
            view1           => {
                class       => 'PPEEMS::SHOPDWG1::view',
                defines     => {
                    general => [qw/teilzngs_holen ftp_liste read_teilzng
                                ascii_lists/],
                    apb     => [qw/create_apb_hp_bmfs/],
                    shop    => [qw/shop_pdf/],
                    '+BPSCSV'=> [qw/bpscsv2swd_liste bpscsv2apb_liste
                                 /],
                                
                },
                strategies  => {
                    general => 'c_gen',
                    apb     => 'c_apb',
                    shop    => 'c_shop',
                    BPSCSV  => 'c_bpscsv',
                }
            },
        },
        
        controler           => {
            c_gen            => {
                class       => 'PPEEMS::SHOPDWG1::c_general',
                defines     => {start    => [qw/get_teilzngs printtrace/],
                                teilzngs => [qw/tzps set_teilzng_paths/],
                                ftp_liste=> [qw/ konstrukteur datum
                                               daten_fuer_ftpliste
                                               pfad_fuer_ftp_liste
                                               excel_liste_ausschreiben/
                                            ],
                                ascii    => [qw/import_ascii_lists
                                             
                                             /],
                                },
                strategies  => {start => 'm_db',
                                teilzngs => 'm_db',
                                ftp_liste=> 'm_ftpliste',
                                ascii    => 'm_b3d_imp',
                },
            },
            c_apb           => {
                class       => 'PPEEMS::SHOPDWG1::c_apb_hp_bmf',
                defines     => {m_db    => [qw/printtrace get_tzdata zdata
                                            apbpos_act get_header_headertexts
                                            hdfile hdtxtvars teilzngs
                                            get_teilzng_paths set_sizes
                                            get_single_template
                                            get_frame_sizes
                                            set_apbzng2apbpos
                                            set_eintrag_teilzeichnung_erstellt
                                            /],
                },
                strategies  => {m_db => 'm_db',
                },
            },
            c_shop          => {
                class       => 'PPEEMS::SHOPDWG1::c_shop_pdf',
                defines     => {m_db    => [qw/printtrace get_wzdata zdata
                                            get_header_headertexts hdfile
                                            hdtxtvars
                                            teilzngs get_teilzng_paths
                                            get_single_template
                                            get_frame_sizes
                                            get_apbposs2b3dpos
                                            /],
                },
                strategies  => {m_db => 'm_db',
                },
            },
            c_bpscsv        => {
                class       => 'PPEEMS::SHOPDWG1::c_bpscsv',
                defines     => {'+DSTV'    => [qw/printtrace
                                            
                                            /],
                                '+SWD'     => [qw/printtrace
                                            
                                            /],
                                '+APB'     => [qw/printtrace
                                            
                                           
                                            /],
                },
                strategies  => {'DSTV' => 'm_dstv',
                                'SWD'  => 'm_swd',
                                'APB'  => 'm_apb',
                },
            },
            
        },
        
        model               => {
            m_db            => {
                class       => 'PPEEMS::SHOPDWG1::m_db',
                observers   => [qw/view1/]
            },
            m_ftpliste      => {
                class       => 'PPEEMS::SHOPDWG1::m_ftpliste',
                observers   => [qw/view1/]
            },
            m_b3d_imp       => {
                class       => 'PPEEMS::SHOPDWG1::m_b3d_imp',
                observers   => [qw/view1/]
            },
            m_dstv          => {
                class       => 'PPEEMS::STL::m_dstv_stl',
                observers   => [qw/view1/]
            },
            m_swd           => {
                class       => 'PPEEMS::STL::m_swd_stl',
                observers   => [qw/view1/]
            },
            m_apb           => {
                class       => 'PPEEMS::STL::m_apb_stl',
                observers   => [qw/view1/]
            },
        }
    };
}


1;
