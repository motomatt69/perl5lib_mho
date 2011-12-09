#!/usr/bin/perl -w
use strict;
use File::Spec;
use File::Slurp;
use MHO_DB::TABS;

#vergleich();
gewicht();

sub gewicht{
    my $cdbh = MHO_DB::TABS->new();
    my @hwss = $cdbh->hws_vergleich->retrieve_all();
    
    for my $hws (@hwss) {
        my ($hws_id) = $hws->pr_hws_dat_ID();
        my ($pr_hws_dat) = $cdbh->pr_hws_dat->search(ID => $hws_id);
        my $hws_nh = $pr_hws_dat->nh();
        my ($hwsh)= $hws_nh =~ m/(\d+)/; 
        my $hwsG = $pr_hws_dat->G();
        
        my $hea_iy = $hws->nh_Iy_HEA();
        if ($hea_iy == 0) {next};
        my $hea_as = $hws->nh_ASteg_HEA();
        my $hea = ($hea_iy <= $hea_as) ? $hea_as : $hea_iy;
        
        my ($pr_hea) = $cdbh->pr_hea_dat->search(nh => $hea);
        my $heaG = $pr_hea->G();
        my $heah = $pr_hea->h();
        
        if ($heah > $hwsh){next};
        
        my $gesG = $hws->g_in_matbest1();
        my $diffG = ($gesG * $heaG / $hwsG) - $gesG;
        
        print "$hws_nh $hea $gesG $diffG\n";
        
        $hws->gew_HEA($diffG);
        
        #heb
        my $heb_iy = $hws->nh_Iy_HEB();
        if ($heb_iy == 0) {next};
        my $heb_as = $hws->nh_ASteg_HEB();
        my $heb = ($heb_iy <= $heb_as) ? $heb_as : $heb_iy;
        
        my ($pr_heb) = $cdbh->pr_heb_dat->search(nh => $heb);
        my $hebG = $pr_heb->G();
        my $hebh = $pr_heb->h();
        
        if ($hebh > $hwsh){next};
        
        $gesG = $hws->g_in_matbest1();
        $diffG = ($gesG * $hebG / $hwsG) - $gesG;
        
        print "$hws_nh $heb $gesG $diffG\n";
        
        $hws->gew_HEB($diffG);
        
        #hem
        my $hem_iy = $hws->nh_Iy_HEM();
        if ($hem_iy == 0) {next};
        my $hem_as = $hws->nh_ASteg_HEM();
        my $hem = ($hem_iy <= $hem_as) ? $hem_as : $hem_iy;
        
        my ($pr_hem) = $cdbh->pr_hem_dat->search(nh => $hem);
        my $hemG = $pr_hem->G();
        my $hemh = $pr_hem->h();
        
        if ($hemh > $hwsh){next};
        
        $gesG = $hws->g_in_matbest1();
        $diffG = ($gesG * $hemG / $hwsG) - $gesG;
        
        print "$hws_nh $hem $gesG $diffG\n";
        
        $hws->gew_HEM($diffG);
        
        $hws->update();
        
        #ipe
        my $ipe_iy = $hws->nh_Iy_IPE();
        if ($ipe_iy == 0) {next};
        my $ipe_as = $hws->nh_ASteg_IPE();
        my $ipe = ($ipe_iy <= $ipe_as) ? $ipe_as : $ipe_iy;
        
        my ($pr_ipe) = $cdbh->pr_ipe_dat->search(nh => $ipe);
        my $ipeG = $pr_ipe->G();
        my $ipeh = $pr_ipe->h();
        
        if ($ipeh > $hwsh){next};
        
        $gesG = $hws->g_in_matbest1();
        $diffG = ($gesG * $ipeG / $hwsG) - $gesG;
        
        print "$hws_nh $ipe $gesG $diffG\n";
        
        $hws->gew_IPE($diffG);
        
        #hws_spezi
        my $hws_spezi_iy = $hws->nh_Iy_HWS_spezi();
        if ($hws_spezi_iy == 0) {next};
        my $hws_spezi_as = $hws->nh_ASteg_IPE();
        my $hws_spezi = ($hws_spezi_iy <= $hws_spezi_as) ? $hws_spezi_as : $hws_spezi_iy;
        
        my ($pr_hws) = $cdbh->pr_hws_dat->search(nh => $hws_spezi);
        my $hws_speziG = $pr_hws_dat->G();
        my $hws_spezih = $pr_hws_dat->h();
        
        if ($hws_spezih > $hwsh){next};
        
        $gesG = $hws->g_in_matbest1();
        $diffG = ($gesG * $hws_speziG / $hwsG) - $gesG;
        
        print "$hws_nh $hws_spezi $gesG $diffG\n";
        
        $hws->gew_HWS_spezi($diffG);
        
        $hws->update();
    }
}
sub vergleich{
    my $cdbh = MHO_DB::TABS->new();
    my @hwss = $cdbh->hws_vergleich->search(in_matbest1 => 1);
    my @heas = $cdbh->pr_hea_dat->retrieve_all();
    my @hebs = $cdbh->pr_heb_dat->retrieve_all();
    my @hems = $cdbh->pr_hem_dat->retrieve_all();
    my @ipes = $cdbh->pr_ipe_dat->retrieve_all();
    my @hwss_spezi = $cdbh->hws_vergleich->search(in_spezi => 1);
    
    my (%hws_spezi_Iy, %hws_spezi_asteg);
    for my $hws_spezi (@hwss_spezi){
        my $id = $hws_spezi->pr_hws_dat_id();
        my ($pr_hws_dat) = $cdbh->pr_hws_dat->search(ID => $id);
        my $Iy = $pr_hws_dat->Iy();
        my $nh = $pr_hws_dat->nh();
        $hws_spezi_Iy{$nh} = $Iy;
        
        my $h = $pr_hws_dat->h();
        my $tg = $pr_hws_dat->tg();
        my $ts = $pr_hws_dat->ts();
        my $asteg = ($h - $tg) * $ts / 100;
        $hws_spezi_asteg{$nh} = $asteg;
    }
    
    for my $hws (@hwss){
        
        my ($hws_id) = $hws->pr_hws_dat_ID();
        my ($pr_hws_dat) = $cdbh->pr_hws_dat->search(ID => $hws_id);
        my $Iy = $pr_hws_dat->Iy();
        
        my $h = $pr_hws_dat->h();
        my $tg = $pr_hws_dat->tg();
        my $ts = $pr_hws_dat->ts();
        my $asteg = ($h - $tg) * $ts / 100;
        
        for my $hea (@heas){
            if ($hea->Iy() >= $Iy){
                $hws->nh_Iy_HEA($hea->nh());
                last
            }
        }
        for my $hea (@heas){
            if ($hea->ASteg() >= $asteg){
                $hws->nh_ASteg_HEA($hea->nh());
                last
            }
        }
        for my $heb (@hebs){
            if ($heb->Iy() >= $Iy){
                $hws->nh_Iy_HEB($heb->nh());
                last
            }
        }
        for my $heb (@hebs){
            if ($heb->ASteg() >= $asteg){
                $hws->nh_ASteg_HEB($heb->nh());
                last
            }
        }
        for my $hem (@hems){
            if ($hem->Iy() >= $Iy){
                $hws->nh_Iy_HEM($hem->nh());
                last
            }
        }
        for my $hem (@hems){
            if ($hem->ASteg() >= $asteg){
                $hws->nh_ASteg_HEM($hem->nh());
                last
            }
        }
        for my $ipe (@ipes){
            if ($ipe->Iy() >= $Iy){
                $hws->nh_Iy_IPE($ipe->nh());
                last
            }
        }
        for my $ipe (@ipes){
            if ($ipe->ASteg() >= $asteg){
                $hws->nh_ASteg_IPE($ipe->nh());
                last
            }
        }
        for my $key (sort {$hws_spezi_Iy{$a} <=> $hws_spezi_Iy{$b}} keys %hws_spezi_Iy){
            if ($hws_spezi_Iy{$key} >= $Iy){
                $hws->nh_Iy_HWS_spezi($key);
                last 
            }
        }
        for my $key (sort {$hws_spezi_asteg{$a} <=> $hws_spezi_asteg{$b}} keys %hws_spezi_asteg){
            if ($hws_spezi_asteg{$key} >= $asteg){
                $hws->nh_Asteg_HWS_spezi($key);
                last 
            }
        }
        $hws->update();
    }
}
    #if ($pr_hws) {
    #    my $id = $pr_hws->ID();
    #    my $hws_vergleich = $cdbh->hws_vergleich->find_or_create(pr_hws_dat_ID => $id,
    #                                                             guete => $hws->[6]);
    #    
    #    $hws_vergleich->in_matbest1(1);
    #    $hws_vergleich->l_in_matbest1($hws->[5]);
    #    $hws_vergleich->g_in_matbest1($hws->[8]);
    #    $hws_vergleich->update();
    #    
    #}
    #else{
    #    print "$bez nicht in db\n";
    #}
    


#my @dirs = qw(c: dummy);
#my $f = 'hwsgesamt.csv';
#my $p = File::Spec->catfile(@dirs, $f);
#
#my @lines = read_file($p);
#
#my @hwss = map {[(split ';', $_)]} grep {$_ =~ m/SUMME\S*HWS/} @lines;
#
#for my $hws (@hwss){
#    
#    my $bez = $hws->[2];
#    my ($reihe, $nh) = $bez =~ /^(HWS|QWS)(\d+\*\d+\*\d+\*\d+)/;
#    $nh =~ s/\*/X/g;
#    $reihe = lc $reihe;
#    
#    my $cdbh = MHO_DB::TABS->new();
#    my ($pr_hws) = $cdbh->pr_hws_dat->search({nh => $nh});
#    
#    if ($pr_hws) {
#        my $id = $pr_hws->ID();
#        my $hws_vergleich = $cdbh->hws_vergleich->find_or_create(pr_hws_dat_ID => $id,
#                                                                 guete => $hws->[6]);
#        
#        $hws_vergleich->in_matbest1(1);
#        $hws_vergleich->l_in_matbest1($hws->[5]);
#        $hws_vergleich->g_in_matbest1($hws->[8]);
#        $hws_vergleich->update();
#        
#    }
#    else{
#        print "$bez nicht in db\n";
#    }
#    
#}
#
#







#my @dirs = qw(c: dummy);
#my $f = 'angebotshws.txt';
#my $p = File::Spec->catfile(@dirs, $f);
#
#my @lines = read_file($p);
#
#my @hwss = map {$_ =~ m/(HWS\d+\*\d+\*\d+\*\d+)/} @lines;
#
#for my $hws (@hwss){
#    
#    my ($reihe, $nh) = $hws =~ /^(HWS|QWS)(\d+\*\d+\*\d+\*\d+)/;
#    $nh =~ s/\*/X/g;
#    $reihe = lc $reihe;
#    
#    my $cdbh = MHO_DB::TABS->new();
#    my ($hws) = $cdbh->pr_hws_dat->search({nh => $nh});
#    
#    if ($hws) {
#        my $id = $hws->ID();
#        my @hws_vergleichs = $cdbh->hws_vergleich->search(pr_hws_dat_ID => $id);
#                                                                
#        for my $hws_vergleich (@hws_vergleichs){
#            
#            $hws_vergleich->in_spezi(1);
#            $hws_vergleich->update();
#        }
#        
#    }
#    
#}

