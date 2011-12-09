#!/usr/bin/perl -w
use strict;
use Tk;

use PROFILE::CROSEC::view;
use PROFILE::CROSEC::controler;
use PROFILE::CROSEC::m_cro_hws;
use PROFILE::CROSEC::m_cro_qws;
use PROFILE::CROSEC::m_cro_tws;
use PROFILE::CROSEC::m_cro_iprofil;
use PROFILE::CROSEC::m_ral;
use PROFILE::CROSEC::m_sketch_size;
use PROFILE::CROSEC::m_batch;

use PROFILE::CROSEC::m_csv2boc3d;

my $mw = MainWindow->new(-title => 'Blechträger');

my $view            = PROFILE::CROSEC::view->new($mw);
my $m_cro_hws       = PROFILE::CROSEC::m_cro_hws->new();
my $m_cro_qws       = PROFILE::CROSEC::m_cro_qws->new();
my $m_cro_tws       = PROFILE::CROSEC::m_cro_tws->new();
my $m_cro_iprofil   = PROFILE::CROSEC::m_cro_iprofil->new();
my $m_ral           = PROFILE::CROSEC::m_ral->new();
my $m_sketch_size   = PROFILE::CROSEC::m_sketch_size->new();
my $m_batch         = PROFILE::CROSEC::m_batch->new();
my $m_csv2boc3d     = PROFILE::CROSEC::m_csv2boc3d->new();
my $control         = PROFILE::CROSEC::controler->new(  $view,
                                                        $m_cro_hws,
                                                        $m_cro_qws,
                                                        $m_cro_tws,
                                                        $m_cro_iprofil,
                                                        $m_ral,
                                                        $m_sketch_size,
                                                        $m_batch,
                                                        $m_csv2boc3d );

$view->set_controler($control);

$m_cro_hws->addObserver($view);
$m_cro_qws->addObserver($view);
$m_cro_tws->addObserver($view);
$m_cro_iprofil->addObserver($view);


$view->init;

Tk::MainLoop;