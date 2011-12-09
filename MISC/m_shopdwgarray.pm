package PPEEMS::SHOPDWG::shopdwg;

use strict;
use File::RGlob;
use File::Slurp;
use PDF::API2;
use integer;

use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw());

sub get_list_bps{
    my ($self) = @_;
    
    $self->{vol} = 'c:';
    my @dirs = ($self->{vol},
                'dummy',
                'server',
                'lists');
    
    my $f = '090477_Eemshaven1.txt';
    my $p = File::Spec->catfile(@dirs, $f);
    
    my @lines = File::Slurp::read_file($p);
    @lines = grep {$_ =~ m/^[H|W]/} @lines;
    map {$_ =~ s/,/\./g} @lines;
    @lines = map {[split ';', $_]} @lines;
    
    my (%hs, $tspos);
    for my $l (@lines){
        if ($l->[0] eq 'H'){
            my $ts = $l->[1];
            my $pos = $l->[2];
            $tspos = $ts * 1000000 + $pos;
            print "H: $tspos\n";
            $hs{$tspos} = undef;
            next
        }
        elsif ($l->[0] eq 'W'){
            if ($hs{$tspos}){
                my @abts = @{$hs{$tspos}};
                push @abts, $l;
                $hs{$tspos} = \@abts;
            }
            else{
                $hs{$tspos} = [$l]
            }
        }
    }
    
    $self->{hs} = \%hs;
}

sub get_sizes{
    my ($self) = @_;
    
    my $pdf = PDF::API2->new();
    $self->{pdf} = $pdf;
    $self->{HB} = $pdf->corefont('Helvetica-Bold');
    $self->{otls} = $pdf->outlines();
    
    my %hs = %{$self->{hs}};
    
    my @dirs = ($self->{vol},
                'dummy',
                'server',
                'pdf');
    
    my $npage;
    my ($np) = 1;
    
    $pdf= $self->_newa0page($pdf);
    $npage = $pdf->openpage(0);
    
    $self->{cntzng} = 11; #erste Zeichnungsnummer = 11
    my $cnt;
    for my $hp (sort keys %hs) { 
        #Zeichnung öffnen  
        my $b3df = 'p'. sprintf "%.12d", $hp;
        $b3df .= '.pdf';
        my $p = File::Spec->catfile(@dirs, $b3df);
        my $old = PDF::API2->open($p);
        my $pageold = $old->openpage(0);
        my ($llx, $lly, $urx, $ury) = $pageold->get_mediabox();
        my $opw = $urx - $llx;
        my $oph = $ury - $lly;
        print "$b3df opw: $opw  oph: $oph\n";
        
        my ($spx, $spy) = ($self->{spx}, $self->{spy});
SP:     while ($spy <= $self->{cntpgr}){
            while ($spx <= $self->{cntpgc}){
                $self->startplatz_finden();
                my $ok = $self->check_area($opw, $oph);
                $spx = $self->{spx};
                $spy = $self->{spy};
                if ($ok == 1){
                    my $gfx = $npage->gfx;
                    my $xo = $pdf->importPageIntoForm($old,0);
                    $gfx->formimage($xo, $self->{spx}, $self->{spy}, 1);
                    last SP;
                    $cnt ++;
                }
                if ($self->{newpage} ==1){
                    print "Neue Seite!!\n;"
                }
                
            }
            
        }
        if ($cnt == 4) {last}
    }

    $npage = $self->test_array($npage);
    
    my $dummy;
        
    @dirs = ($self->{vol},
                'dummy',
                'server',
                'fertig');
    my $f = 'fertig.pdf';
    my $p = File::Spec->catfile(@dirs, $f);    
    print "$f speichern...\n";
    $pdf->saveas($p);
    print "   ...gespeichert\n";
}

sub _newa0page{
    my ($self, $pdf) = @_;
    
    my $page = $pdf->page(0);
    my $pw = 3368; #pagewidth
    my $ph = 2382; #pageheight
    $page->mediabox($pw, $ph);
    
    if ($pdf->pages == 1){ 
        #Array anlegen
        my $pg;#Seiten ref
        
        #Plankopfbereich
        for my $r (0..842){
            for my $c (($pw - 595)..$pw){
                $pg->[$r][$c] = 2;
            }
        }
        #randbreite
        my $rd = 20;
        #rand_unten
        for my $r (0..$rd){
            for my $c (0..$pw){
                $pg->[$r][$c] = 1;
            }
        }
        #rand_links
        for my $r (0..$ph){
            for my $c (0..$rd){
                $pg->[$r][$c] = 1;
            }
        }
        #rand_rechts
        for my $r (0..$ph){
            for my $c (($pw - $rd)..$pw){
                $pg->[$r][$c] = 1;
            }
        }
        #rand_oben
        for my $r (($ph - $rd)..$ph){
            for my $c (0..$pw){
                $pg->[$r][$c] = 1;
            }
        }
             
        $self->{pg} = $pg;
        my @pgr = @$pg;
        $self->{cntpgr} = @pgr - 1;
        $self->{cntpgc} = @{$pgr[0]} - 1;
    }
    
    $self->{blatt} = $self->{otls}->outline();
    my $nop = $pdf->pages();
    $self->{blatt}->title("Blatt $nop");
    $self->{blatt}->dest($page, -fit => 1);
    
    return $pdf;
}

sub startplatz_finden{
    my ($self) = @_;     
        
    my $pg = $self->{pg};
        
    my ($spx, $spy) = ($self->{spx}, $self->{spy});   
SP: while ($spy <= $self->{cntpgr}){
        if (!(grep{!defined} @{$pg->[$spy]})){
            $spy++;
            next};
        while ($spx <= $self->{cntpgc}){
            print "r: $spy  c: $spx val: ",$pg->[$spy][$spx],"\n";
            if (!defined $pg->[$spy][$spx]){
                $self->{spx} = $spx;
                $self->{spy} = $spy;
                last SP;
            }
        $spx++
        }
        $spx = 0;
        $spy++;
    }
}

sub check_area{
    my ($self, $opw, $oph) = @_;
    
    my ($spx, $spy) = ($self->{spx}, $self->{spy});
    
    my $epy = $spy + $oph;
    my $epx = $spx + $opw;
    
    my $pg = $self->{pg};
    
    if ($epy > $self->{cntpgr}){
        $self->startpunkt_weitersetzen();
        return 0
    }
    if ($epx > $self->{cntpgc}){
        $self->startpunkt_weitersetzen();
        return 0
    }
    
    my $besetzt;
    my $r = $spy;
    while ($r <= $epy){
        #print "$r\n";
        my @frei = grep {defined} @{$pg->[$r]}[$spx..$epx];
        if (@frei){
            print "besetzt reihe $r\n";
            $besetzt++
        }
        $r++;
    }
    
    my $dummy;
    if (defined $besetzt){
        $self->startpunkt_weitersetzen();
        return 0
    }
    else{
        for my $r ($spy..$epy){
            map {$_ = $self->{cntzng}} @{$pg->[$r]}[$spx..$epx];
            $self->{cntzng}++;
        }
    }
        
    return 1;
}

sub startpunkt_weitersetzen{
    my ($self) = @_;
    
    my ($spx, $spy) = ($self->{spx}, $self->{spy});
    
    if ($spx <= $self->{cntpgc}){
            $self->{spx}++
    }
    elsif($spx == $self->{cntpgc}){
        $self->{spx} = 0;
        $self->{spx} ++
    }
    elsif($spy == $self->{cntpgr}){
        $self->{newpage} = 1
    }
}

sub test_array{
    my ($self, $npage) = @_;    

    my $pg = $self->{pg};
    my @pgr = @$pg;
    my $cntpgr = @pgr;
    my $cntpgc = @{$pgr[0]};
    
    my $txt = $npage->text;
    $txt->font($self->{HB}, 10);
    $txt->transform( -translate => [0, 0]);
   
    
    my ($r, $c) = (0, 0);
    while ($r <= $cntpgr){
        while ($c <= $cntpgc){
            print "r: $r  c: $c\n";
            $txt->transform( -translate => [$c, $r]);
            $txt->text($pg->[$r][$c]);            
            $c += 10
        }
        $c = 0;
        $r += 10;
    }
    return $npage;
}



package main;
use strict;

my $shopdwg = PPEEMS::SHOPDWG::shopdwg->new();
$shopdwg->get_list_bps();
$shopdwg->get_sizes();


1;