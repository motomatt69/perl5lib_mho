#!/usr/bin/perl -w
use strict;
use DB::Archiv qw (get_auftrag);

#my ($auftrag) = get_auftrag(anr => '090171');
#my @zngs = $auftrag->zng_data->retrieve_all;#only_last_index();
#print $auftrag->(),"\n\n";

#for my $z (@zngs) {
#    print "\t", $z->zng_data_znr();
#    print "\t", $z->zng_data_beschrieb(),"\n";
    #print "\t", $z->zng_group_2->zng_group_bez(),"\n";
#}

my @anrs=DB::Archiv::auf_data->retrieve_all;
#print @anrs;

for my $anr (@anrs) {
    print "\t",$anr->auf_data_anr;
    print "\t",$anr->auf_data_ag,"\n"
}

my @zngs = DB::Archiv::zng_data->retrieve('051014');

for my $z (@zngs) {
    print "\t",$z->zng_data_anr;
    #print "\t",$anr->auf_data_ag,"\n"
}