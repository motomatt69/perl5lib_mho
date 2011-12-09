#!/usr/bin/perl -w
use strict;
use XBase;

my ($v, $ds, $f) = (qw(c: /dummy/st_prm zpos.dbf));

my $p = File::Spec->canonpath(File::Spec->catpath($v, $ds, $f));

my $t = new XBase "$p" or die XBase->errstr;
#for my $i (0..$t->last_record){
    my ($x) = $t->get_all_records();
 #   get_record("PNR", "ANZAHL", "BEZEICHNG");
    
    #print "$pos, $anz, $bez\n"
#}



my $dummy


