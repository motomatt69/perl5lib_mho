package Misc::Tk::bltr;
use strict;
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(h b ts tg aw poly));

sub get_plates{
    my ($self) = @_;
    
    factor_und_startpunkt($self);
    
    my ($fac, $start_x, $start_y) = ($self->{fac}, $self->{start_x}, $self->{start_y});
                                     
    my ($h, $b, $ts, $tg, $r) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{r}); 
    
    #U-Flansch
    my @p0xy = ($start_x - ($b / 2) * $fac, $start_y - ($h / 2 * $fac));  
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
    my @snaht_pkte = (\@p4xy, \@p5xy, \@p6xy, \@p7xy); 
    $self->{snaht_pkte} = \@snaht_pkte;
    
    #O-Flansch
    my @p8xy = ($p0xy[0], $p0xy[1]+ ($h - $tg) * $fac);
    my @p9xy = ($p0xy[0] + $b * $fac, $p0xy[1]+ ($h - $tg) * $fac);
    my @p10xy = ($p0xy[0] + $b * $fac, $p0xy[1] + $h * $fac);
    my @p11xy = ($p0xy[0], $p0xy[1] + $h * $fac);
    my @ofl =  (@p8xy, @p9xy, @p10xy, @p11xy);
    
    my @pkte = (\@p0xy, \@p1xy, \@p2xy, \@p3xy, \@p4xy, \@p5xy, \@p6xy, \@p7xy, \@p8xy, \@p9xy, \@p10xy, \@p11xy); 
    $self->{pkte} = \@pkte;
    
    my @plates = (\@ufl, \@steg, \@ofl);     
    
    return \@plates;
}
    
sub factor_und_startpunkt  {
    my ($self) = @_;
    
    my ($canvh, $canvb) = (500, 500); 
    $self->{canvh} = $canvh;
    $self->{canvb} = $canvb;
    
    my ($h, $b) = ($self->{h}, $self->{b});
    
    my $fac_x = ($canvb * 0.8) / $b;
    my $fac_y = ($canvh * 0.8 / $h);
    
    my $fac = ($fac_x <= $fac_y) ? $fac_x : $fac_y;
    $self->{fac} = $fac;
    
    my $start_x = $canvb / 2;
    $self->{start_x} = $start_x;
    my $start_y = $canvh / 2;
    $self->{start_y} = $start_y;
    
    return ;
}
    
sub get_snaht{
    my ($self) = @_;
    
    my $aw = $self->{aw};#a-Maß
    my $zw = $aw * sqrt(2) * $self->{fac};#z-Maß
    
    my @zw4 = ($zw * (-1), 0, 0, $zw * 1);
    my @zw5 = ($zw * 1, 0, 0, $zw * 1);
    my @zw10 = ($zw * 1, 0, 0, $zw * (-1));
    my @zw11 = ($zw * (-1), 0, 0, $zw * (-1));
    
    my @zws = (\@zw4, \@zw5, \@zw10, \@zw11);
    
    my $snaht_pkte_ref = $self->{snaht_pkte};
    my @snaht_pkte = @$snaht_pkte_ref;
    my $cnt = 0;
    foreach my $snaht_pkt (@snaht_pkte) {
        $snaht_pkt->[2] = $snaht_pkt->[0] + $zws[$cnt][0];
        $snaht_pkt->[3] = $snaht_pkt->[1] + $zws[$cnt][1];
        $snaht_pkt->[4] = $snaht_pkt->[0] + $zws[$cnt][2];
        $snaht_pkt->[5] = $snaht_pkt->[1] + $zws[$cnt][3];
        $cnt++;
    }
    
    return \@snaht_pkte;

}

sub get_dim {
    my ($self) = @_;
    my (@dimlines, @dimtxt);
    
    my ($h , $b, $ts, $tg, $aw) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw});
    my ($canvb, $canvh, $fac) = ($self->{canvb}, $self->{canvh}, $self->{fac});
    my ($start_x, $start_y) = ($self->{start_x}, $self->{start_y});
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    
    my $delta_x = 25;
    my $delta_y = 25;
    my $delta_x_steg = $b / 4 * $fac;
    my $delta_y_steg = ($h - 2 * $tg) / 4 * $fac;
    
    #maßketten und text für höhe
    {my @p0xy = ($pkte[11][0] - $delta_x, $start_y + 10);
     my @p1xy = ($pkte[11][0] - $delta_x, $pkte[11][1]);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($pkte[0][0] - $delta_x, $start_y - 10);
     my @p3xy = ($pkte[0][0] - $delta_x, $pkte[0][1]);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($pkte[11][0] - $delta_x, $start_y);
     unshift @txt, $h;
     push @dimtxt, \@txt;
     }
    
    #maßkette und txt für breite
    {my @p0xy = ($start_x - 20, $pkte[11][1] + $delta_y);
     my @p1xy = ($pkte[11][0], $pkte[11][1] + $delta_y);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($start_x + 20, $pkte[10][1] + $delta_y);
     my @p3xy = ($pkte[10][0], $pkte[10][1] + $delta_y);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($start_x, $pkte[11][1] + $delta_y);
     unshift @txt, $b;
     push @dimtxt, \@txt;
     }
    
     #maßkette für flanschdicke
    {my @p0xy = ($pkte[0][0] + $delta_x_steg, $pkte[0][1] - 20);
     my @p1xy = ($pkte[0][0] + $delta_x_steg, $pkte[0][1]);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($pkte[3][0] + $delta_x_steg, $pkte[3][1] + 20);
     my @p3xy = ($pkte[3][0] + $delta_x_steg, $pkte[3][1]);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($pkte[0][0] + $delta_x_steg +15, $pkte[0][1] - 15);
     unshift @txt, $tg;
     push @dimtxt, \@txt;
     }
    
     #maßkette für stegdicke
    {my @p0xy = ($pkte[4][0] - 20, $pkte[4][1] + $delta_y_steg);
     my @p1xy = ($pkte[4][0], $pkte[4][1] + $delta_y_steg);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($pkte[5][0] + 20, $pkte[5][1] + $delta_y_steg);
     my @p3xy = ($pkte[5][0], $pkte[5][1] + $delta_y_steg);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($pkte[5][0] + 15, $pkte[5][1] + $delta_y_steg - 15);
     unshift @txt, $ts;
     push @dimtxt, \@txt;
     }
    
    #maßkette für snaht
    {my @txt = ($pkte[6][0] + 15, $pkte[6][1] - 15);
     unshift @txt, $aw;
     push @dimtxt, \@txt;
    }
     
    return (\@dimlines, \@dimtxt);
}

sub get_sysline{
    my ($self) = @_;
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    my @syslines;
    
    my @p0xy = ($pkte[0][0] - 10, ($pkte[0][1] + $pkte[11][1]) / 2);
    my @p1xy = ($pkte[1][0] + 10, ($pkte[0][1] + $pkte[11][1]) / 2);
    my @sysline0 = (@p0xy, @p1xy);
    push @syslines, \@sysline0;
    my @p2xy = (($pkte[0][0] + $pkte[1][0]) / 2, $pkte[0][1] - 10);
    my @p3xy = (($pkte[0][0] + $pkte[1][0]) / 2, $pkte[11][1] + 10);
    my @sysline1 = (@p2xy, @p3xy);
    push @syslines, \@sysline1;
    
    return \@syslines;
}
1;    
    

