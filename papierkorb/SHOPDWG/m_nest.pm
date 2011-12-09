package PPEEMS::SHOPDWG::m_nest;
use Moose;
use Math::Polygon;

has 'frm'            => (isa => 'HashRef',  is => 'rw', required => 0);
has 'hdr'            => (isa => 'HashRef',  is => 'rw', required => 0);
has 'teilzngsizes'   => (isa => 'HashRef',  is => 'rw', required => 0);
has 'zng'            => (isa => 'ArrayRef', is => 'ro', required => 0);

sub nest{
    my ($self) = @_;
    
    my $cnt = 0;
    
    my %szngs = %{$self->{teilzngsizes}};
    my %szngs_ph = map {$_ => $szngs{$_}->{ph}} keys %szngs;
    
    my @zng = @{$self->_newpage()};
    
    #Teileschleife
TS: for my $key (sort {$szngs_ph{$b} <=> $szngs_ph{$a}} keys %szngs_ph){
        $cnt++;
        #print "teilzng Nr: $cnt\n";
        $self->{'zng_'.$cnt} = $key;
        #Blattschleife
PGS:    for (my $pnr = 0; $pnr <= $#zng; $pnr++){
            
            my @pts = $zng[$pnr]->{poly}->points(); #Polygonpunkte für Blatt
            
            my $opw = $szngs{$key}->{pw}; #Abmessungen Zeichnung
            my $oph = $szngs{$key}->{ph}; #Abmessungen Zeichnung
            
            my $nested = 0;
    PTS:    for (my $i = 0; $i <= $#pts; $i++){
                my $ptx = $pts[$i]->[0];       # Startpunkt Polygon
                my $pty = $pts[$i]->[1];
                
                my @npts = ([$ptx + 1, $pty - 1], #Zeichnungspunkte
                            [$ptx + 1, $pty - $oph - 1],
                            [$ptx + $opw - 1, $pty - $oph - 1],
                            [$ptx + $opw - 1, $pty - 1]
                            );
                
                my ($cntinpoly, $cntpt) = (0, 0); #Überprüfung ob alle Punkte im Polygon
                for my $npt (@npts){
                    if  ($zng[$pnr]->{poly}->contains($npt)){
                        $cntinpoly++;
                        #print "$cntpt: inpoly\n";
                        $cntpt++;
                        }
                    else{
                        #print "$cntpt: not inpoly\n";
                        $cntpt++;
                    }
                }
                #print "pkt $i gecheckt\n";
                if ($cntinpoly == 4){
                    @npts = ([$ptx, $pty],
                             [$ptx, $pty - $oph],
                             [$ptx + $opw, $pty - $oph],
                             [$ptx + $opw, $pty],
                             [$ptx, $pty]
                            );
                    my ($crash) = $self->_check_zeichnungskollision(\@npts, $pnr, \@zng);
                    if ($crash == 1) {next}; 
                    $zng[$pnr]->{boxes}->{$cnt} = \@npts; #Punkte der Zeichnung abspeichern
                    $zng[$pnr]->{teilzngs}->{$cnt} = $key;  #Name der Zeichnung abspeichern
                                        
                    #Polygon anpassen
                    pop @pts;
                    my @bispts = @pts[0..($i - 1)];
                    my @abpts = @pts[($i + 1)..$#pts];
                    @pts = [];
                    $pts[0] = $npts[3];
                    push @pts, @abpts;
                    push @pts, @bispts;
                    push @pts, $npts[1];
                    push @pts, $npts[2];
                    push @pts, $pts[0];
                    
                    $zng[$pnr]->{poly} = Math::Polygon->new(@pts);
                    my @pts = $zng[$pnr]->{poly}->points();
                   
                    $nested = 1;
                    last PTS
                }
            }
            if ($nested != 1 && $pnr == $#zng){
                if (defined $self->{keyakt} && $self->{keyakt} eq $key){
                    #print "$key zu groß fuer ",$self->{frm}->{bez},"\n";
                    return 0;
                    }
                $self->{keyakt} = $key;
                
                #print "neue Seite\n";
                @zng = @{$self->_newpage(\@zng)};
                redo;
            }
            elsif ($nested == 1){
                last PGS
            }   
        }
    }
    $self->{zng} = \@zng;
    return 1;
}

sub _newpage{
    my ($self, $zngref) = @_;
    
    my ($nop, @zng);
    if (!defined $zngref){
        $nop = 0;
    }
    else{
        @zng = @$zngref;
        $nop = $#zng;
        $nop ++;        
    }
    my $frmpw = $self->{frm}->{pw};#3368;
    $zng[$nop]->{pw} = $frmpw; #pagewidth
    my $frmph = $self->{frm}->{ph};#2382;
    $zng[$nop]->{ph} = $frmph; #pageheight
    
    $zng[$nop]->{frm} = $self->{frm}->{file};
    
    my $hdrpw = $self->{hdr}->{pw};#3368;
    my $hdrph = $self->{hdr}->{ph};#2382;
    
    my $rd = 15;
    $zng[$nop]->{poly} = Math::Polygon->new([0 + $rd, $frmph - $rd],
                                                [$frmpw - $rd, $frmph - $rd],
                                                [$frmpw - $rd, $hdrph + $rd],
                                                [$frmpw - $rd - $hdrpw, $hdrph + $rd],
                                                [$frmpw - $rd - $hdrpw, $rd],
                                                [$rd, $rd],
                                                [0 + $rd, $frmph - $rd]);
    
    my @hdrpts = ([$frmpw - $rd - $hdrpw, $hdrph + $rd],
                  [$frmpw - $rd - $hdrpw, $rd],
                  [$frmpw - $rd, $rd],
                  [$frmpw - $rd, $hdrph + $rd],
                  );
    
    $zng[$nop]->{hdrbox} = \@hdrpts;
    
    return \@zng;
}


sub _check_zeichnungskollision{
    my ($self, $nptsref, $pnr, $zngref) = @_;
    
    my @zng = @$zngref;
    
    my $nll = $nptsref->[1];
    my $nur = $nptsref->[3];
    
    if (!defined $zng[$pnr]->{boxes}) {return 0}
    
    my %boxes = %{$zng[$pnr]->{boxes}};
    for my $box (sort keys %boxes){
        my $ll = $boxes{$box}->[1];
        my $ur = $boxes{$box}->[3];
        
        if ($nll->[0] >= $ur->[0]) {next}
        if ($nll->[1] >= $ur->[1]) {next}
        if ($nur->[0] <= $ll->[0]) {next}
        if ($nur->[1] <= $ll->[1]) {next}
        
        #print "box kollidiert\n";
        return 1
    }
    return 0
}
1;