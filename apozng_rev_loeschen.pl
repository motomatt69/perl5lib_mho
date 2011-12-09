#!/usr/bin/perl -w
use strict;

use DB::SWD;

my $dbh = DB::SWD->new()->dbh();

my $znr = '148210_21224_0247',
my $revnr = '00';

my ($aposzng_rev_id) = $dbh->selectrow_array(qq(
    SELECT hv_aposzng_rev
    FROM hv_aposzng_rev
    WHERE projekt = '090477'
    AND block = 2
      AND alstomznr LIKE '%21224%'
    AND revnr = '00'
    ORDER BY block, alstomznr, revnr DESC
    ));


my $dummy;


