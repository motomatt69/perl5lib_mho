#!/usr/bin/perl -w
use strict;
use MHO_DB::TABS;

my $cdbh = MHO_DB::TABS->new();

my @hwss = $cdbh->pr_hws_dat->retrieve_all();

for my $rec (@hwss){
    my $nh = $rec->nh();
    
    $nh =~ s/\*/X/g;
    print "$nh\n";
    
    $rec->nh($nh);
    $rec->update();
}

