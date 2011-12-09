package PROFILE::BLTR::m_cro;
use strict;
use PROFILE::BLTR::m_cro::cro_bltr;
#use base 'DesignPatterns::MVC::Model';
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(cs_canv_data));

sub add_observer {
    my ($self, $observer) = @_; 
    my $observer_ref=$self->{'Observer'};
    push @$observer_ref, $observer;
    $self->{'Observer'}=$observer_ref;
    return
}

sub notify {
    my ($self, $message) = @_;
    my $observer_ref = $self->{'Observer'};
    
    for my $observer (@$observer_ref) {
        $observer->recieveMessage($self,$message);
    }
}

sub set_reihe{
    my($self, $reihe) = @_;
    
    $self->{reihe} = $reihe;
}

sub set_size{
    my ($self, $size) = @_;
    $self->{size} = $size;
    $self->{h} = $size->[0];
    $self->{b} = $size->[1];
    $self->{ts} = $size->[2];
    $self->{tg} = $size->[3];
    $self->{aw} = $size->[4];
}

sub set_cs_canv_data {
    my ($self) = @_;
    
    factor_und_startpunkt($self);
    
    my $reihe = $self->{reihe};
    
    my $crovals = PROFILE::BLTR::m_cro::cro_bltr->new();
    $crovals->set_factor_und_startpunkt($self->{start_x},
                                        $self->{start_y},
                                        $self->{fac});
    my %cs_canv_data = ('plates' => $self->calc_plates(),
                        'snaht' => $self->calc_snaht(),
                        'dimlinetxt' => $self->calc_dim(),
                        'sys' => $self->calc_sysline(),
                        'g' => $self->calc_gewicht(),
                        'u' => $self->calc_umfang(),
                        );
    
        $self->{cs_canv_dat} = \%cs_canv_data;
        $self->notify( \%cs_canv_data)    
}

sub set_sketch_size{
    my($self, $sketch_size) = @_;
    
    $self->{sketch_size} = $sketch_size;
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
    $colors{h} = ('red') if ($h <= 2 * $tg);
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

sub get_val_res{
    my ($self) = @_;
    return $self->{val_res}
}



sub calc_plates{
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
    
    my $sketch_size_ref = $self->{sketch_size};
    my %sketch_size = %$sketch_size_ref;
    my $sk_h = $sketch_size{sk_h};
    my $sk_b = $sketch_size{sk_b};
    
    $self->{sk_h} = $sk_h;
    $self->{sk_b} = $sk_b;
    
    my ($h, $b) = ($self->{h}, $self->{b});
    
    my $fac_x = ($sk_b * 0.8) / $b;
    my $fac_y = ($sk_h * 0.8 / $h);
    
    my $fac = ($fac_x <= $fac_y) ? $fac_x : $fac_y;
    $self->{fac} = $fac;
    
    #my $start_x = $sketch_size{sk_startx};
    #$self->{start_x} = $start_x;
    #my $start_y = $sketch_size{sk_starty};
    #$self->{start_y} = $start_y;
    
    $self->{start_x} = $sketch_size{sk_startx};
    $self->{start_y} = $sketch_size{sk_starty};
    
    return ;
}
    
sub calc_snaht{
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

sub calc_dim {
    my ($self) = @_;
    my (@dimlines, @dimtxt);
    
    my ($h , $b, $ts, $tg, $aw) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw});
    my ($sk_b, $sk_h, $fac) = ($self->{sk_b}, $self->{sk_h}, $self->{fac});
    my ($start_x, $start_y) = ($self->{start_x}, $self->{start_y});
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    
    my $delta_x = $sk_b / 20;
    my $delta_y = $sk_h / 20;
    my $delta_x_steg = $b / 4 * $fac;
    my $delta_y_steg = ($h - 2 * $tg) / 4 * $fac;
    
    #maßketten und text für höhe
    {my @p0xy = ($pkte[11][0] - $delta_x, $start_y + $sk_h / 30);
     my @p1xy = ($pkte[11][0] - $delta_x, $pkte[11][1]);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($pkte[0][0] - $delta_x, $start_y - $sk_h / 30);
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
    {my @txt = ($pkte[6][0] + $sk_b / 15, $pkte[6][1] - $sk_h / 15);
     unshift @txt, "DK $aw";
     push @dimtxt, \@txt;
    }
     
    my @dimlinetxt = (\@dimlines, \@dimtxt);
    return \@dimlinetxt;
}

sub calc_sysline{
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

sub calc_gewicht{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
    my $g = (2 * $b * $tg + ($h - 2 * $tg) * $ts) * 0.00785;
    $g = sprintf "%.2f", $g;
    
    return $g;
}

sub calc_umfang{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
    my $u = (2 * $h + 4 * $b - 2 * $ts) / 1000;
    $u = sprintf "%.2f", $u;
    
    return $u;
}
    
1;    
    

