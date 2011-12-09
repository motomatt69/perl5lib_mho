#!/usr/bin/perl -w
use strict;
use MHO_DB::TABS;

my $cdbh = MHO_DB::TABS->new();

my @qwss = $cdbh->pr_qws_dat->retrieve_all();

for my $rec (@qwss){
    my $nh = $rec->nh();
    
    my ($nhnew) = $nh =~ m/QWS(\S*)/;
    print "$nhnew\n";
    
    $rec->nh($nhnew);
    $rec->update();
}

