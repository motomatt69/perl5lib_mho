#!/usr/bin/perl -w
use strict;
use Tk;
use PPEEMS::DB::PPEEMS;
use PPEEMS::SHOPDWG_1::view;
use PPEEMS::SHOPDWG_1::controler;

use PPEEMS::SHOPDWG_1::m_db;

my $mw = MainWindow->new(-title => 'SHOPDRAWING');

my $view = PPEEMS::SHOPDWG_1::view->new(mw => $mw);

my $cdbh = PPEEMS::DB::PPEEMS->new();
my $dbh = $cdbh->dbh();

my $m_db     = PPEEMS::SHOPDWG_1::m_db->new(cdbh => $cdbh,
                                          dbh => $dbh,);

my $controler   = PPEEMS::SHOPDWG_1::controler->new(view => $view,
                                              m_db => $m_db,
                                              );


$view->controler($controler);
$controler->addObserver($view);
$m_db->addObserver($view);

$view->init();

Tk::MainLoop();