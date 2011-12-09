#!/usr/bin/perl -w
use strict;
use Tk;

use PROFILE::CROSEC::view;
use PROFILE::CROSEC::controler;
use PROFILE::CROSEC::m_cro_hws;
use PROFILE::CROSEC::m_ral;
use PROFILE::CROSEC::m_reihe;
use PROFILE::CROSEC::m_sketch_size;

my $mw = MainWindow->new(-title => 'Blechträger');

my $view    = PROFILE::CROSEC::view->new($mw);
my $m_cro_hws   = PROFILE::CROSEC::m_cro_hws->new();
my $m_ral   = PROFILE::CROSEC::m_ral->new();
my $m_reihe = PROFILE::CROSEC::m_reihe->new();
my $m_sketch_size = PROFILE::CROSEC::m_sketch_size->new();
my $control = PROFILE::CROSEC::controler->new($view,
                                            $m_cro_hws,
                                            $m_ral,
                                            $m_reihe,
                                            $m_sketch_size);

$view->set_controler($control);
$m_cro_hws->add_observer($view);


$view->init;

Tk::MainLoop;