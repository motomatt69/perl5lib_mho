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

my $dbh = $sdb->dbh();
my $sth = $dbh->prepare(q{
select a.hv_htzngbl_rev
from hv_htzngbl_rev a
left join aposzng_rev2htzngbl_rev b on a.hv_htzngbl_rev = b.htzngbl_rev
join crdata c on b.aposzng_rev = c.crdata
where a.tsnummer = 106180
and a.htnr = '10819'
and a.revnr = '01'
and (b.aposzng_rev2htzngbl_rev is null or c.aktiv = 0)
});

$sth->execute();
my $ids = $sth->fetchall_arrayref;

my @ids = map { $_->[0]; } @$ids;
#unshift @ids, '4F950924-B6B9-11E0-8C16-128BC6E120AA';



for my $id (@ids){
    $dbh->do(qq(
       update crdata
       set aktiv = 0 where crdata = '$id'
    ));
    $dbh->commit();
}





#my @htzngbl_rev = map { $sdb->htzngbl_rev->retrieve($_); } @ids;
#
#for my $htzngbl_rev (@htzngbl_rev) {
#eval {
#    $htzngbl_rev->update();
#    $htzngbl_rev->update();
##    $aposzng_rev->remove();
#    $sdb->commit();
#};
#
#if ($@) {
#    my $error = $@;
#    eval { $sdb->rollback();};
#    
#    print "$error\n";
#}
#}
my $dummy;

print "fertig";