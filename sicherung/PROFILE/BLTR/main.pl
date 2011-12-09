#!/usr/bin/perl -w
use strict;
use Tk;

use PROFILE::BLTR::view;
use PROFILE::BLTR::controler;
use PROFILE::BLTR::m_cro;
use PROFILE::BLTR::m_ral;


my $mw = MainWindow->new(-title => 'Blechträger');

my $view  = PROFILE::BLTR::view->new($mw);
my $m_cro   = PROFILE::BLTR::m_cro->new();
my $m_ral   = PROFILE::BLTR::m_ral->new();
my $control = PROFILE::BLTR::controler->new($view, $m_cro, $m_ral);

$view->set_controler($control);
$m_cro->add_observer($view);



$view->init;

Tk::MainLoop;