#!/usr/bin/perl -w
use strict;


use DB::SWD;
use DB::SWD::AppInfo qw(initAppInfo :set);
#use DB::Archiv;
use File::RGlob;
use File::Spec;
use File::Copy;
use DB::SWD::Exchange::File;

use PPEEMS::DB::PPEEMS;

my $sdb = DB::SWD->new(1);
my $edb = PPEEMS::DB::PPEEMS->new();

initAppInfo($sdb->dbh);
setAppInfoUser('Kaupp');
setAppInfoOrder('090477');

package PPEEMS::Uebernahme::MHO;
use DB::SWD::AppInfo qw(:set);
use version; our $VERSION = qv('0.0.0');

setAppInfoApplication();

package main;

#my @crdata;
#my ($projekt)       = $sdb->projekt->search('nummer' => '090477');
#my ($teilsystem)    = $sdb->teilsystem->search(tsnummer => '224201');
my ($hv_hauptteil)     = $sdb->hv_hauptteil->search(
    projekt => '090477',
    tsnummer => '106180',
    htnr => '10819'
);

my $id = $hv_hauptteil->hv_hauptteil();

my $dbh = $sdb->dbh();
my $ok = $dbh->do(qq(
       update crdata
       set aktiv = 0 where crdata = '$id'
    ));
    $dbh->commit();

##my $htzngbl   = $sdb->htzngbl->retrieve($v_htzngbl->id());
#my $hauptteil = $sdb->hauptteil->retrieve($hv_hauptteil->id());
#
#
#eval {
#    $hauptteil->remove();
#    #$htzngbl->remove();
#    $sdb->commit();
#};
#
#if ($@) {
#    my $error = $@;
#    eval { $sdb->rollback(); };
#    print "$error\n";
#}

print "fertig";