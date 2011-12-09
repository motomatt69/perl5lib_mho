#!/usr/bin/perl -w
use strict;

use PPEEMS::DB::PPEEMS;

my $cdbh = PPEEMS::DB::PPEEMS->new();

$cdbh->bauteil2rohling->set_sql(count_bt_id => "SELECT COUNT(*) FROM __TABLE__ WHERE bauteil_id = ?");
my $count = $cdbh->bauteil2rohling->sql_count_bt_id->select_val(7300);

my $dummy
