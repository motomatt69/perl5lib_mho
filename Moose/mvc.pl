#!/usr/bin/perl -w
use strict;
use Moose::ctrl_main;
use Moose::m_db;


my $m_db = Moose::m_db->new();
my $ctrl_main = Moose::ctrl_main->new(m_db => $m_db);

$ctrl_main->get_data();


