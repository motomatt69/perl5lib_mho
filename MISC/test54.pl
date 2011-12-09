#!/usr/bin/perl -w
use strict;
use Tk;

my @hposls_db = (1001, 1002 ,1003, 1004);
my @hposls_ps = (1001, 1002 ,1003, 1005);

my (%vergleich, @db_only, @ps_only);
@vergleich{@hposls_db} = ();
@ps_only = grep{!exists $vergleich{$_}} @hposls_ps;

%vergleich = ();
@vergleich{@hposls_ps} = ();
@db_only = grep{!exists $vergleich{$_}} @hposls_db;



my $dummy;



