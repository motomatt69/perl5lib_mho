package PROFILE::CROSEC::m_cro_iprofil;
use strict;

use Patterns::Observer qw(:subject);
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(cs_canv_data));

sub set_reihe{
    my ($self, $reihe) = @_;
     
    if (!defined $self->{reihe}){
        $self->{rowchange} = 1
    }
    elsif ($self->{reihe} eq $reihe){
        $self->{rowchange} = 0
    }
    else{
        $self->{rowchange} = 1
    }
    $self->{reihe} = $reihe;
}

sub set_nh{
    my ($self, $nh) = @_;
    $self->{nh} = $nh;
}

sub set_profgeo{
    my ($self) = @_;
        
    my ($ids_ref, $nhs_ref);
    if ($self->{rowchange} == 1){
        ($ids_ref, $nhs_ref) = $self->do_profhoehen();
    }
    my $nh = $self->{nh};
    
    my $dat_tab = $self->TabelleDerProfilreihe($self->{reihe});
        
    $self->{dbh} = $self->{cdbh}->dbh();
    my $dbh = $self->{dbh};
    
    my $sth = $dbh->prepare(qq{
        SELECT h, b, ts, tg, r
        FROM $dat_tab
        WHERE nh = $nh
        });
        
    $sth->execute();
        
    while (my $val_ref = $sth->fetchrow_arrayref()){
        $self->{h} =  $val_ref->[0];
        $self->{b} =  $val_ref->[1];
        $self->{ts} = $val_ref->[2];
        $self->{tg} = $val_ref->[3];
        $self->{r} =  $val_ref->[4];
    }
    $sth->finish;
    
    my @size = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{r});
    
    my @rowvals = ($self->{ids}, $self->{nhs}, \@size);
    $self->{rowvals}=\@rowvals;
    $self->notify('anzeige_reihe');
}

sub do_profhoehen {
    my ($self) =  @_;
        
    my (@ids, @nhs); 
    
    $self->{cdbh} = DB::MHO_DB::TABS->new();
        
    my $dat_tab = $self->TabelleDerProfilreihe($self->{reihe});
        
    $self->{dbh} = $self->{cdbh}->dbh();
    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare(qq{
        SELECT ID, nh
        FROM $dat_tab
        });
    
    $sth->execute();
              
    while (my $val_ref = $sth->fetchrow_arrayref()){
        push @ids, $val_ref->[0];
        push @nhs, $val_ref->[1];
    }
    $sth->finish;

    $self->{nh} = $nhs[0];
    
    $self->{ids} = \@ids;
    $self->{nhs} = \@nhs;
        
}

sub TabelleDerProfilreihe{
    my ($self, $reihe) = @_;
    
    my $cdbh = $self->{cdbh};
    my ($reihe_rec) = $cdbh->pr_prof_main->search ({row_name => $reihe});
    my ($dat_tab) = $reihe_rec->row_tab_dat();
    
    return $dat_tab;
}


sub get_rowvals{
    my ($self) = @_;
    
    return $self->{rowvals};
}
1;    
    
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
                        'values' => $self->calc_values(),
                        #'u' => $self->calc_umfang(),
                        );
    
    $self->{cs_canv_dat} = \%cs_canv_data;
    $self->notify('anzeigewerte');    
}



sub set_validate{
    my ($self) = @_;
    
    my $nh = $self->{nh};
    my @val_res;
    my %colors = qw(h black b black ts black tg black aw black);

    $colors{h} = ('red') if (!defined $nh);
    $colors{b} = ('red') if (!defined $nh);
    $colors{ts} = ('red') if (!defined $nh);
    $colors{tg} = ('red') if (!defined $nh);
    $colors{aw} = ('red') if (!defined $nh);
    
    if ($colors{h} eq 'red') {
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

sub get_h{
    my ($self) = @_;
    
    return $self->{h}
}

sub get_b{
    my ($self) = @_;
    
    return $self->{b}
}

sub get_val_res{
    my ($self) = @_;
    return $self->{val_res}
}

sub get_canv_data_ref{
    my ($self) = @_;
    
    return $self->{cs_canv_dat}
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
    
sub calc_snaht{
    my ($self) = @_;
    
    my $aw = $self->{r};#a-Maß
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
    
    my ($h , $b, $ts, $tg, $aw) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{r});
    my ($sk_b, $sk_h, $fac) = ($self->{sk_b}, $self->{sk_h}, $self->{fac});
    my ($startx, $starty) = ($self->{startx}, $self->{starty});
    
    my $pkte_ref = $self->{pkte};
    my @pkte = @$pkte_ref;
    
    my $delta_x = $sk_b / 20;
    my $delta_y = $sk_h / 20;
    my $delta_x_steg = $b / 4 * $fac;
    my $delta_y_steg = ($h - 2 * $tg) / 4 * $fac;
    
    #maßketten und text für höhe
    {my @p0xy = ($pkte[11][0] - $delta_x, $starty + $sk_h / 30);
     my @p1xy = ($pkte[11][0] - $delta_x, $pkte[11][1]);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($pkte[0][0] - $delta_x, $starty - $sk_h / 30);
     my @p3xy = ($pkte[0][0] - $delta_x, $pkte[0][1]);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($pkte[11][0] - $delta_x, $starty);
     unshift @txt, $h;
     push @dimtxt, \@txt;
     }
    
    #maßkette und txt für breite
    {my @p0xy = ($startx - 20, $pkte[11][1] + $delta_y);
     my @p1xy = ($pkte[11][0], $pkte[11][1] + $delta_y);
     my @dimline0 = (@p0xy, @p1xy);
     push @dimlines, \@dimline0;
     my @p2xy = ($startx + 20, $pkte[10][1] + $delta_y);
     my @p3xy = ($pkte[10][0], $pkte[10][1] + $delta_y);
     my @dimline1 = (@p2xy, @p3xy);
     push @dimlines, \@dimline1;
     my @txt = ($startx, $pkte[11][1] + $delta_y);
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

#sub calc_gewicht{
#    my ($self) = @_;
#    
#    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
#    my $g = (2 * $b * $tg + ($h - 2 * $tg) * $ts) * 0.00785;
#    $g = sprintf "%.2f", $g;
#    
#    return $g;
#}
#
#sub calc_umfang{
#    my ($self) = @_;
#    
#    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
#    my $u = (2 * $h + 4 * $b - 2 * $ts) / 1000;
#    $u = sprintf "%.2f", $u;
#    
#    return $u;
#}

sub calc_values{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg});
    my $g = (2 * $b * $tg + ($h - 2 * $tg) * $ts) * 0.00785;
    $g = sprintf "%.2f", $g;
    
    return $g;
}    
1;    
    

