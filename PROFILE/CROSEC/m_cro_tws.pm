package PROFILE::CROSEC::m_cro_tws;
use strict;

use Patterns::Observer qw(:subject);
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(h b cs_canv_dat val_res));

sub set_size{
    my ($self, $size) = @_;
    $self->{size} = $size;
    $self->{h} = $size->[0];
    $self->{b} = $size->[1];
    $self->{ts} = $size->[2];
    $self->{tg} = $size->[3];
    $self->{aw} = $size->[4];
}

sub set_sketchvals{
    my ($self, %sketchvals) = @_;
    
    $self->{fac} = $sketchvals{fac};
    $self->{startx} = $sketchvals{startx};
    $self->{starty} = $sketchvals{starty};
    $self->{sk_h} = $sketchvals{sk_h};
    $self->{sk_b} = $sketchvals{sk_b};
}

sub set_cs_canv_data {
    my ($self) = @_;
    
    my %cs_canv_data = ('plates' => $self->calc_plates(),
                        'snaht' => $self->calc_snaht(),
                        'dimlinetxt' => $self->calc_dim(),
                        'sys' => $self->calc_sysline(),
                        'vals' => $self->calc_vals(),
                        );
    
    $self->{cs_canv_dat} = \%cs_canv_data;
    $self->notify('anzeigewerte');    
}


                       
sub set_validate{
    my ($self) = @_;
    
    my @val_res;
    my %colors = qw(h black b black ts black tg black aw black);

    my $h = $self->{h};
    my $b = $self->{b};
    my $ts = $self->{ts};
    my $tg = $self->{tg};
    my $aw = $self->{aw};
    
    
    $colors{h} = ('red') if ($h =~ m{^[0A-Za-z]*$}xms);
    $colors{h} = ('red') if ($h <= $tg);
    $colors{b} = ('red') if ($b =~ m{^[0A-Za-z]*$}xms);
    $colors{b} = ('red') if ($b <= $ts);
    $colors{ts} = ('red') if ($ts =~ m{^[0A-Za-z]*$}xms);
    $colors{tg} = ('red') if ($tg =~ m{^[0A-Za-z]*$}xms);
    $colors{aw} = ('red') if ($aw =~ m{^[A-Za-z]*$}xms);
        
    
    my ($cnt_red) = 0;
    foreach my $key (keys %colors) {
        if ($colors{$key} eq 'red') {
            $cnt_red++;   
        }
    }
    if ($cnt_red > 0) {
        $val_res[0] = 'notvalid';
        $val_res[1] = \%colors;
        $self->{val_res} = \@val_res;
    }
    else{
        $val_res[0] = 'valid';
        $val_res[1] = \%colors;
        $self->{val_res} = \@val_res;
    }
}

sub calc_plates{
    my ($self) = @_;
    
    my ($fac, $startx, $starty) = ($self->{fac}, $self->{startx}, $self->{starty});
                                     
    my ($h, $b, $ts, $tg, $r) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{r}); 
    
    #U-Flansch
    my @p0xy = ($startx - ($b / 2) * $fac, $starty - ($h / 2 * $fac));  
    my @p1xy = ($p0xy[0] + $b * $fac, $p0xy[1]);
    my @p2xy = ($p0xy[0] + $b * $fac, $p0xy[1]+ $tg * $fac);
    my @p3xy = ($p0xy[0], $p0xy[1]+ $tg * $fac);
    my @ufl =  (@p0xy, @p1xy, @p2xy, @p3xy);
     
    
    #Steg
    my @p4xy = ($p0xy[0] + ($b / 2 - $ts / 2) * $fac, $p0xy[1] + $tg * $fac );
    my @p5xy = ($p0xy[0] + ($b / 2 + $ts / 2) * $fac, $p0xy[1] + $tg * $fac );
    my @p6xy = ($p0xy[0] + ($b / 2 + $ts / 2) * $fac, $p0xy[1] + ($h - $tg) * $fac);
    my @p7xy = ($p0xy[0] + ($b / 2 - $ts / 2) * $fac, $p0xy[1] + ($h - $tg) * $fac);
    my @steg =  (@p4xy, @p5xy, @p6xy, @p7xy);
    
    #S-Naht Punkte;
    my @snaht_pkte = (\@p4xy, \@p5xy);#, \@p6xy, \@p7xy); 
    $self->{snaht_pkte} = \@snaht_pkte;
    
    my @pkte = (\@p0xy, \@p1xy, \@p2xy, \@p3xy, \@p4xy, \@p5xy, \@p6xy, \@p7xy);# \@p8xy, \@p9xy, \@p10xy, \@p11xy); 
    $self->{pkte} = \@pkte;
    
    my @plates = (\@ufl, \@steg);# \@ofl);     
    
    return \@plates;
}
    
sub calc_snaht{
    my ($self) = @_;
    
    my $aw = $self->{aw};#a-Maß
    my @snaht_pkte;
    if ($aw < 8) {
        my $zw = $aw * sqrt(2) * $self->{fac};#z-Maß
        
        my @zw4 = ($zw * (-1), 0, 0, $zw * 1);
        my @zw5 = ($zw * 1, 0, 0, $zw * 1);
        
        my @zws = (\@zw4, \@zw5);#, \@zw10, \@zw11);
        
        my $snaht_pkte_ref = $self->{snaht_pkte};
        @snaht_pkte = @$snaht_pkte_ref;
        my $cnt = 0;
        foreach my $snaht_pkt (@snaht_pkte) {
            $snaht_pkt->[2] = $snaht_pkt->[0] + $zws[$cnt][0];
            $snaht_pkt->[3] = $snaht_pkt->[1] + $zws[$cnt][1];
            $snaht_pkt->[4] = $snaht_pkt->[0] + $zws[$cnt][2];
            $snaht_pkt->[5] = $snaht_pkt->[1] + $zws[$cnt][3];
            $cnt++;
        }
    }
    else{
        my $zw = $aw  * $self->{fac};#z-Maß
        
        my @zw4 = ($zw * (1), 0, 0, $zw * (1));
        my @zw5 = ($zw * (-1), 0, 0, $zw * (1));

        my @zws = (\@zw4, \@zw5);#, \@zw10, \@zw11);
        
        my $snaht_pkte_ref = $self->{snaht_pkte};
        @snaht_pkte = @$snaht_pkte_ref;
        my $cnt = 0;
        foreach my $snaht_pkt (@snaht_pkte) {
            $snaht_pkt->[2] = $snaht_pkt->[0] + $zws[$cnt][0];
            $snaht_pkt->[3] = $snaht_pkt->[1] + $zws[$cnt][1];
            $snaht_pkt->[4] = $snaht_pkt->[0] + $zws[$cnt][2];
            $snaht_pkt->[5] = $snaht_pkt->[1] + $zws[$cnt][3];
            $cnt++;
        }
    }
    
    return \@snaht_pkte;

}

sub calc_dim {
    my ($self) = @_;
    my (@dimlines, @dimtxt);
    
    my ($h , $b, $ts, $tg, $aw) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw});
    my ($sk_b, $sk_h, $fac) = ($self->{sk_b}, $self->{sk_h}, $self->{fac});
    my ($startx, $starty) = ($self->{startx}, $self->{starty});
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    
    my $delta_x = $sk_b / 20;
    my $delta_y = $sk_h / 20;
    my $delta_x_steg = $b / 4 * $fac;
    my $delta_y_steg = ($h - 2 * $tg) / 4 * $fac;
    
    #maßketten und text für höhe
    {   my @p0xy = ($pkte[0][0] - $delta_x, $starty + $sk_h / 30);
        my @p1xy = ($pkte[0][0] - $delta_x, $pkte[6][1]);
        my @dimline0 = (@p0xy, @p1xy);
        push @dimlines, \@dimline0;
        my @p2xy = ($pkte[0][0] - $delta_x, $starty - $sk_h / 30);
        my @p3xy = ($pkte[0][0] - $delta_x, $pkte[0][1]);
        my @dimline1 = (@p2xy, @p3xy);
        push @dimlines, \@dimline1;
        my @txt = ($pkte[0][0] - $delta_x, $starty);
        unshift @txt, $h;
        push @dimtxt, \@txt;
     }
    
    #maßkette und txt für breite
    {   my @p0xy = ($startx - 20, $pkte[6][1] + $delta_y);
        my @p1xy = ($pkte[0][0], $pkte[6][1] + $delta_y);
        my @dimline0 = (@p0xy, @p1xy);
        push @dimlines, \@dimline0;
        my @p2xy = ($startx + 20, $pkte[6][1] + $delta_y);
        my @p3xy = ($pkte[1][0], $pkte[6][1] + $delta_y);
        my @dimline1 = (@p2xy, @p3xy);
        push @dimlines, \@dimline1;
        my @txt = ($startx, $pkte[6][1] + $delta_y);
        unshift @txt, $b;
        push @dimtxt, \@txt;
     }
    
     #maßkette für flanschdicke
    {my @p0xy = ($pkte[0][0] + $delta_x_steg, $pkte[0][1] - $sk_h / 15);
        my @p1xy = ($pkte[0][0] + $delta_x_steg, $pkte[0][1]);
        my @dimline0 = (@p0xy, @p1xy);
        push @dimlines, \@dimline0;
        my @p2xy = ($pkte[3][0] + $delta_x_steg, $pkte[3][1] + $sk_h / 15);
        my @p3xy = ($pkte[3][0] + $delta_x_steg, $pkte[3][1]);
        my @dimline1 = (@p2xy, @p3xy);
        push @dimlines, \@dimline1;
        my @txt = ($pkte[0][0] + $delta_x_steg + $sk_b / 15, $pkte[0][1] - $sk_h / 15);
        unshift @txt, $tg;
        push @dimtxt, \@txt;
     }
    
     #maßkette für stegdicke
    {my @p0xy = ($pkte[4][0] - $sk_b / 15, $pkte[4][1] + $delta_y_steg);
        my @p1xy = ($pkte[4][0], $pkte[4][1] + $delta_y_steg);
        my @dimline0 = (@p0xy, @p1xy);
        push @dimlines, \@dimline0;
        my @p2xy = ($pkte[5][0] + $sk_b / 15, $pkte[5][1] + $delta_y_steg);
        my @p3xy = ($pkte[5][0], $pkte[5][1] + $delta_y_steg);
        my @dimline1 = (@p2xy, @p3xy);
        push @dimlines, \@dimline1;
        my @txt = ($pkte[5][0] + $sk_b / 15, $pkte[5][1] + $delta_y_steg - $sk_h / 15);
        unshift @txt, $ts;
        push @dimtxt, \@txt;
     }
    
    #maßkette für snaht
    {my @txt = ($pkte[6][0] + $sk_b / 15, $pkte[5][1] + $sk_h / 15);
        if ($aw < 8){
            unshift @txt, "DK $aw";
            push @dimtxt, \@txt;
        }
        else{
            unshift @txt, "DHY $aw";
            push @dimtxt, \@txt;
        }
    }
     
    my @dimlinetxt = (\@dimlines, \@dimtxt);
    return \@dimlinetxt;
}

sub calc_sysline{
    my ($self) = @_;
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    my @syslines;
    
    my @p2xy = (($pkte[0][0] + $pkte[1][0]) / 2, $pkte[0][1] - 10);
    my @p3xy = (($pkte[0][0] + $pkte[1][0]) / 2, $pkte[6][1] + 10);
    my @sysline1 = (@p2xy, @p3xy);
    push @syslines, \@sysline1;
    
    return \@syslines;
}

sub calc_vals{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
    
    my %vals;
    $vals{bez} = 'TWS'.$h.'*'.$b.'*'.$ts.'*'.$tg;
    $vals{h} = $h;
    $vals{b} = $b;
    $vals{ts} = $ts;
    $vals{tg} = $tg;
    my $G = ($b * $tg + ($h - $tg) * $ts) * 0.00785;
    $G = sprintf "%.2f", $G;
    $vals{G} = $G;
    my $U = (2 * $h + 2 * $b) / 1000;
    $U = sprintf "%.2f", $U;
    $vals{U} = $U;
    my $A = $b * $tg + ($h - $tg) * $ts;
    $vals{A} = $A; 
    my $ASteg = ($h - $tg) * $ts;
    $vals{ASteg} = $ASteg;
    
    my $zsz = ($b * $tg**2 /2 + ($h - $tg) * $ts * ($tg + ($h - $tg)/2)) / $A;
    
    
    my $Iy = (1 / 12 * ($tg**3 * $b)
              + 1 / 12 * ($h - $tg)**3 * $ts
              + $b * $tg * ($zsz - $tg / 2)**2
              + ($h - $tg) * $ts * (($tg + ($h - $tg)/2) - $zsz)**2)/ 10000; 
    $Iy = sprintf "%.0f", $Iy;
    $vals{Iy} = $Iy;
    
    my $Wy = $Iy / (($h - $zsz) / 10);
    $Wy = sprintf "%.0f", $Wy;
    $vals{Wy} = $Wy;
    my $iy =   sqrt($Iy / $A) * 100;
    $iy = sprintf "%.1f", $iy;
    $vals{iy} = $iy;
    my $Iz =   (1 / 12 * $b**3 * $tg
                + 1 / 12 * $ts**3 * ($h - $tg)) / 10000;
    $Iz = sprintf "%.0f", $Iz;
    $vals{Iz} = $Iz;
    my $Wz =   $Iz * 2 / ($b / 10);
    $Wz = sprintf "%.0f", $Wz;
    $vals{Wz} = $Wz;
    my $iz =   sqrt($Iz / $A) * 100;
    $iz = sprintf "%.1f", $iz;
    $vals{iz} = $iz;
    
    my $Sy =   ($b * $tg * ($zsz - $tg / 2)
                + $ts * ($zsz - $tg)**2 /2)  / 1000;
    $Sy = sprintf "%0.f", $Sy;
    $vals{Sy} = $Sy;
    my $Sz =   (($b / 2 )**2 / 2 * $tg ) / 1000;
    $Sz = sprintf "%0.f", $Sz;
    $vals{Sz} = $Sz;
    
    
    
    my $fyd = 218.2;
    my $Vzd235 = ($h - $tg) * $ts * $fyd / sqrt (3) / 1000;
    $Vzd235 = sprintf "%0.f", $Vzd235;
    $vals{Vzd235} = $Vzd235; 
    
    my $Vzd355 = ($h - $tg) * $ts * 1.5 * $fyd / sqrt (3) / 1000;
    $Vzd355 = sprintf "%0.f", $Vzd355;
    $vals{Vzd355} = $Vzd355;
    
    my $Syfl = ($b * $tg) * ($zsz  - $tg /2) / 1000;
    $Syfl = sprintf "%0.f", $Syfl;
    $vals{Syfl} = $Syfl;
    my $sy = $Iy / $Sy;
    $sy = sprintf "%1.f", $sy * 10;
    
    my $aw235 = $Vzd235 * $Syfl / ($Iy * 0.95 * $fyd / 10) * 10;
    my $aw355 = $Vzd355 * $Syfl / ($Iy * 0.8 * 1.5 * $fyd / 10) * 10;
    $aw235 = int $aw235 / 2 + 1;
    $aw355 = int $aw355 / 2 + 1;
    if ($tg <= 21){
        if ($aw235 <= 4) {$aw235 = 4};
        if ($aw355 <= 4) {$aw355 = 4};
    }
    $vals{aw235} = $aw235;
    $vals{aw355} = $aw355;
    my $aw = ($vals{aw235} >= $vals{aw355}) ? $vals{aw235} : $vals{aw355}; 
        
    my $r2 = 0;
    
    $vals{expval3d} = join ',', ($vals{bez}, $A, $h, $b, $ts, $tg, $aw,
                                 $r2, $G, $U, $Iy, $Wy, $iy, $Iz, $Wz,
                                 $iz, $Sy, $sy, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    
    $vals{expvalps} = join ';', ($A, 0, $b, 0, 0, 0, $G, $h, $Iy, $Iz,
                                 $iy /10 , $iz / 10, $U, 0, $vals{bez}, 1,
                                 $aw, 0, $ts, $Sy, $Sz, $tg, 0, 0, 0, 0,
                                 $Wy, $Wz);
    
    return \%vals;
}    
1;    
    

