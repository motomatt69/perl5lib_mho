#!/usr/bin/perl -w
use strict;

use PPEEMS::DB::PPEEMS;

my $cdbh = PPEEMS::DB::PPEEMS->new();

my @tzs = $cdbh->zz_teilzng->search(filetype => 'bmf_');

for my $tz (@tzs){
    my ($ts, $pos, $blatt, $rev) = $tz->file() =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})/;
    my $teilzng_id = $tz->teilzng();
    
    
    my ($tsrec) = $cdbh->zz_ts->search(tsnr => $ts);
    my $ts_id = $tsrec->ts(); 
    
    my ($zngrec) = $cdbh->zz_zng->search(zngnr => $pos,
                                        ts => $ts_id);
    my $zng_id = $zngrec->zng();
    
    my ($revrec) = $cdbh->zz_rev->search(revnr => $rev);
    my $rev_id =$revrec->rev();
    
    my ($zng2revrec) = $cdbh->zz_zng2rev->search(zng => $zng_id,
                                                 rev => $rev_id);
    
    $zng2revrec->blatt($blatt);
    $zng2revrec->teilzng($teilzng_id);
    $zng2revrec->update();
    my $dummy;
}