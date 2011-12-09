#!/usr/bin/perl -w
use strict;

use RDK8FT::DB::RDK8FTP;

my $alstom_id = '81030120';

my ($bt) = RDK8FT::DB::RDK8FTP::bauteil->search(
    alstom_id => $alstom_id,
);

my @at2bt = $bt->anbauteil2bauteil_s();

for my $at2bt (@at2bt) {
    my $at = $at2bt->anbauteil();
    my  @ai = $at->anbauteilindex_s();
    
    my $dummy;
}

my @ind = RDK8FT::DB::RDK8FTP::v_anbauteilliste->search(
   alstom_id => $alstom_id,
                                                       );
my %ind;
for my $ind (@ind) {
    my $pnr = $ind->position();
    next if exists $ind{$pnr};
    $ind{$pnr} = $ind;
}

my $d;