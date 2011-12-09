#!/usr/bin/perl -w
use strict;
use RDK8FT::DB::PROMIX::Colli;

    
my @zngs = RDK8FT::DB::PROMIX::Colli::get_zeichnungen('090408', '1');    
#my %wz_gew = map{$_->zng_nr() => RDK8FT::DB::PROMIX::Colli::get_zeichnungsgewicht($_)} @zngs;

my %wz;
my $i;
for my $z (@zngs){
    my $znr = $z->zng_nr();
    #$wz{$z->zng_nr()}{gew} = RDK8FT::DB::PROMIX::Colli::get_zeichnungsgewicht($z);
    my @aups = RDK8FT::DB::PROMIX::Colli::list_hauptpos($z);
    for my $aup (@aups){
        my $pos = $aup->aup_pos();
        my $gew = RDK8FT::DB::PROMIX::Colli::get_bauteilgewicht('090408', '1',
                                                                $znr, $pos
                                                                );
        $wz{$znr}->{poss}{$pos} = $gew;
    }
    print "$znr\n";
    $i++;
    if ($i > 15) {last};
}
#print "eingelesen\n";

my %ts;
for my $key (sort keys %wz){
    my ($tsnr) = $key =~ m/^\d-(\d{6})/;
    my %hps = %{$wz{$key}->{poss}};
    while (my ($k, $v) = each %hps){
        $ts{$tsnr}->{poss}{$k} = $v;     
    } 
}

for my $key (sort keys %ts){
    my %hps = %{$ts{$key}->{poss}};
    my ($gew, $anz);
    while (my ($k, $v) = each %hps){
        $gew += $v;
        $anz ++;
    }
    $ts{$key}->{gew} = $gew;
    $ts{$key}->{anz} = $anz;
}

#map{print $_.'=>'.$ts_gew{$_},"\n"} sort keys %ts_gew;


    
    my $dummy;
 