#!/usr/bin/perl -w
use strict;
use PPEEMS::ROHLINGE::m_nesting;

my $nesting = PPEEMS::ROHLINGE::m_nesting->new();
$nesting->nest_tsnrs_teilsystemweise();
