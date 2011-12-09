package PPEEMS::SHOPDWG::shopdwg;

use strict;
use File::RGlob;
use File::Slurp;
use PDF::API2;
use Math::Polygon;
use Time::localtime;

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
    
    my $f = '090477_Eemshaven4.txt';
    my $p = File::Spec->catfile(@dirs, $f);
    
    my @lines = File::Slurp::read_file($p);
    @lines = grep {$_ =~ m/^[H|W]/} @lines;
    map {$_ =~ s/,/\./g} @lines;
    @lines = map {[split ';', $_]} @lines;
    
    my (%hplines, $tspos);
    for my $l (@lines){
        if ($l->[0] eq 'H'){
            my $ts = $l->[1];
            my $pos = $l->[2];
            $tspos = $ts * 1000000 + $pos;
            #print "H: $tspos\n";
            $hplines{$tspos} = undef;
            next
        }
        elsif ($l->[0] eq 'W'){
            if ($hplines{$tspos}){
                my @abts = @{$hplines{$tspos}};
                push @abts, $l;
                $hplines{$tspos} = \@abts;
            }
            else{
                $hplines{$tspos} = [$l]
            }
        }
    }
    
    $self->{hplines} = \%hplines;
}

sub get_sizes{
    my ($self) = @_;
    
    my @hps = sort keys %{$self->{hplines}};
    my %hp_sizes;
    
    for my $hp (@hps) {
        my ($opw, $oph) = $self->_open_old_dwg($hp);
        #Zeichnungsgröße für A0 prüfen
        my $toobig;
        if ($opw > 3328) {$toobig = 1}
        if ($oph > 2342) {$toobig = 1}
        if ($opw <= 3328 && $oph >= 1520) {
            if ($opw <= 2850 && $oph >= 2342) {$toobig = 1}
        }
        if ($opw <= 2850 && $oph >= 2342) {
            if ($opw <= 3328 && $oph >= 1520) {$toobig = 1}
        }
        
        if ($toobig == 1){
            print "Zeichnung $hp zu groß fuer A0\n";
            next;
        }
        $hp_sizes{$hp} = $oph;
    }
    
    $self->{hp_sizes} = \%hp_sizes;
}

sub nest{
    my ($self) = @_;
    
    my $pdf = PDF::API2->new();
    $self->{pdf} = $pdf;
    $self->{HB} = $pdf->corefont('Helvetica-Bold');
    $self->{otls} = $pdf->outlines();
    
    $pdf= $self->_newa0page($pdf);
    my $page = $pdf->openpage(0);
    
    my $cnt = 0;
    
    my %hp_sizes = %{$self->{hp_sizes}};
    
    #Teileschleife
    for my $hp (sort {$hp_sizes{$b} <=> $hp_sizes{$a}} keys %hp_sizes){
        $cnt++;
        print "$cnt\n";
        $self->{'zng_'.$cnt} = $hp;
        #Blattschleife
PGS:    for (my $pnr = 1; $pnr <= $pdf->pages(); $pnr++){
            $page = $pdf->openpage($pnr);
            my @pts = $self->{'poly_'.$pnr}->points(); #Polygonpunkte für Blatt
            $page = $self->_printpoly($page, \@pts);
            
            my ($opw, $oph) = $self->_open_old_dwg($hp, $pdf); #Abmessungen Zeichnung
            
            my $nested;
    PTS:    for (my $i = 0; $i <= $#pts; $i++){
                my $ptx = $pts[$i]->[0];       # Startpunkt Polygon
                my $pty = $pts[$i]->[1];
                
                my @npts = ([$ptx + 1, $pty - 1], #Zeichnungspunkte
                            [$ptx + 1, $pty - $oph - 1],
                            [$ptx + $opw - 1, $pty - $oph - 1],
                            [$ptx + $opw - 1, $pty - 1]
                            );
                
                my $cntinpoly; #Überprüfung ob alle Punkte im Polygon
                for my $npt (@npts){
                    if ($self->{'poly_'.$pnr}->contains($npt)){
                        $cntinpoly++;
                        #print "$cntinpoly: inpoly\n";
                        }
                    else{
                        #print "$cntinpoly: not inpoly\n"
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
                    my $crash = $self->_check_zeichnungskollision(\@npts, $pnr);
                    if ($crash == 1) {next}; 
                    $self->{'boxes_'.$pnr}->{$cnt} = \@npts; #Punkte der Zeichnung abspeichern
                                        
                    $page = $self->_printpoly($page, \@npts);
                    
                    my $xo = $pdf->importPageIntoForm($self->{old},0);
                    my $gfx = $page->gfx;
                    $gfx->formimage($xo, $npts[1]->[0], $npts[1]->[1], 1);
                    
                    my $otl_znr = $self->{'blatt_'.$pnr}->outline();
                    $otl_znr->title($hp);
                    $otl_znr->dest($page, -fitr => [$npts[1]->[0],
                                                    $npts[1]->[1],
                                                    $npts[3]->[0],
                                                    $npts[3]->[1]]);
                    
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
                    
                    $self->{'poly_'.$pnr} = Math::Polygon->new(@pts);
                    my @pts = $self->{'poly_'.$pnr}->points();
                    $page = $self->_printpoly($page, \@pts, $cnt);
                   
                    $nested = 1;
                    last PTS
                }
            }
            if ($nested != 1 && $pnr == $pdf->pages()){
                print "neue Seite\n";
                $pdf = $self->_newa0page($pdf);
                redo;
            }
            elsif ($nested == 1){
                last PGS
            }
            
        }
        #if ($cnt == 5) {last}
    }   
    
    $pdf = $self->_header_a0($pdf);
    
    my @dirs = ($self->{vol},
               'dummy',
               'server',
               'fertig');
    my $f = 'fertig.pdf';
    my $p = File::Spec->catfile(@dirs, $f);    
    print "$f speichern...\n";
    $pdf->saveas($p);
    print "   ...gespeichert\n";
}

sub _open_old_dwg{
    my ($self, $hp) = @_;
    
    my $b3df = 'p'. sprintf "%.12d", $hp;
    $b3df .= '.pdf';
    
    my @dirs = ($self->{vol},
                'dummy',
                'server',
                'pdf');
    
    my $p = File::Spec->catfile(@dirs, $b3df);
    my $old = PDF::API2->open($p);
    my $pageold = $old->openpage(0);
    $self->{old} = $old;
    
    my ($llx, $lly, $urx, $ury) = $pageold->get_mediabox();
    my $opw = $urx - $llx;
    my $oph = $ury - $lly;
        
    return ($opw, $oph);
}

sub _newa0page{
    my ($self, $pdf) = @_;
    
    my $page = $pdf->page(0);
    my $pw = 3368; #pagewidth
    $self->{pw} = $pw;
    my $ph = 2382; #pageheight
    $self->{ph} = $ph;
    $page->mediabox($pw, $ph);
    my $rd = 20;
    my $nop = $pdf->pages();
               
    $self->{'poly_'.$nop} = Math::Polygon->new([0 + $rd, $ph - $rd],
                                                [$pw - $rd, $ph - $rd],
                                                [$pw - $rd, 842],
                                                [$pw - 518, 842],
                                                [$pw - 518, $rd],
                                                [$rd, $rd],
                                                [0 + $rd, $ph - $rd]);
    
    $self->{'polyorg_'.$nop} = $self->{'poly_'.$nop};#Wird für scetch gebraucht
    $self->{'blatt_'.$nop} = $self->{otls}->outline();
    $self->{'blatt_'.$nop}->title("Blatt $nop");
    $self->{'blatt_'.$nop}->dest($page, -fit => 1);
    
    return $pdf;
}

sub _printpoly{
    my ($self, $page, $pref, $cnt) = @_;    
    
    my @pts = @$pref;
    my $p0x = $pts[0]->[0];
    my $p0y = $pts[0]->[1];
    
    my $gfx = $page->gfx;
    $gfx->linewidth(3);
    $gfx->move($p0x,$p0y);
    
    for (my $i = 1; $i <= $#pts; $i++){
        my $px = $pts[$i]->[0];
        my $py = $pts[$i]->[1];
        $gfx->line($px, $py);
    }
    $gfx->stroke();
    
    my $hp = $self->{'zng_'.$cnt};
    if ($cnt){
        my $txt = $page->text;
        $txt->transform( -translate => [$p0x - 20 , $p0y - 60]);
        $txt->font($self->{HB}, 42);
        $txt->text_right($hp);
        $txt->stroke;
    }    
    return $page;
}

sub _check_zeichnungskollision{
    my ($self, $nptsref, $pnr) = @_;
    
    my $nll = $nptsref->[1];
    my $nur = $nptsref->[3];
    
    if (!defined $self->{boxes}) {return 0}
    
    my %boxes = %{$self->{'boxes_'.$pnr}};
    for my $box (sort keys %boxes){
        my $ll = $boxes{$box}->[1];
        my $ur = $boxes{$box}->[3];
        
        if ($nll->[0] >= $ur->[0]) {next}
        if ($nll->[1] >= $ur->[1]) {next}
        if ($nur->[0] <= $ll->[0]) {next}
        if ($nur->[1] <= $ll->[1]) {next}
        
        print "box kollidiert\n";
        return 1
    }
    return 0
}

sub _header_a0{
    my ($self, $pdf) = @_;
    
    my $nop = $pdf->pages();
    
    my $date =  (sprintf "%02d", localtime->mday())
                .'.'
                .(sprintf "%02d", localtime->mon() + 1)
                .'.'
                .(sprintf "%4d", localtime->year() + 1900);

    for my $i (1..$nop){
        my $page = $pdf->openpage($i);
        
        #KopfRahmen
        my $frma4 = $page->gfx;
        $frma4->linewidth(5);
        $frma4->fillcolor("black");
        $frma4->rectxy(2850, 20, 3348, 842);
        $frma4->stroke;
        
        my $otl_pk = $self->{'blatt_'.$i}->outline();
        $otl_pk->title("Pk $i");
        $otl_pk->dest($page, -fitr => [2850,
                                        20,
                                        3348,
                                        842]);        
        #oberer rahmen
        my $frmo = $page->gfx;
        $frmo->rectxy(2850, 672, 3348, 842);
        $frmo->stroke;
        
        #logo
        my $vol = '//Server-av/fehler/';
        my @dirs = ($vol, 'logo');
        my $p = File::Spec->catfile(@dirs, 'swdlogo_shopdwg.jpg');
        my $logoswd = $pdf->image_jpeg($p);
        my $logo = $page->gfx;
        $logo->image($logoswd, 2917, 690);
        $logo->stroke;
        
        #bezeichnung
        my $beztxt = $page->text;
        $beztxt->transform( -translate => [2870, 600]);
        $beztxt->font($self->{HB}, 42);
        $beztxt->lead(40);
        $beztxt->text("090477 ALSTOM");
        $beztxt->nl;
        $beztxt->text("Eemshaven Unit A + B");
        $beztxt->stroke;
        
        #bauteile
        #my $zngtxt = $page->text;
        #$zngtxt->transform( -translate => [2870, 460]);
        #$zngtxt->font($self->{HB}, 30);
        #$zngtxt->lead(30);
        #
        ##my %zng2page = %{$self->{zng2page}};
        ##for my $key (sort keys %zng2page){
        ##    my ($pnr) = $key =~ m/_(\d+)/;
        ##    if ($i == $pnr){
        ##        my %zngs = %{$zng2page{$key}};
        ##        for my $zng (sort keys %zngs){
        ##            $zngtxt->text("$zng");
        ##            $zngtxt->nl;
        ##        }
        ##    }
        ##}
        #$zngtxt->stroke;
        
        #Planskizze
        $page = $self->_printscetch($page, $i);
        
        #datetext
        my $dtxt = $page->text;
        $dtxt->transform( -translate => [3331, 113]);
        $dtxt->font($self->{HB}, 20);
        $dtxt->text_right("erstellt am: $date");
                
        #unterer rahmen hintergrund
        my $frmu = $page->gfx;
        $frmu->fillcolor("lightgray");
        $frmu->rectxy(2850, 20, 3348, 108);
        $frmu->fill();
        $frmu->stroke;
        
        #unterer rahmen
        my $frmu1 = $page->gfx;
        $frmu1->fillcolor("black");
        $frmu1->rectxy(2850, 20, 3348, 108);
        $frmu1->stroke;
        
        #Blattnummerierung
        my $pnotxt = $page->text;
        $pnotxt->fillcolor('black');
        $pnotxt->transform( -translate => [3100, 47]);
        $pnotxt->font($self->{HB}, 42);
        $pnotxt->text_center("Blatt $i von $nop");
        
              
    }
    return $pdf;
}

sub _printscetch{
    my ($self, $page, $pnr) = @_;    
    
    my $fagw = 478 / $self->{pw};
    my $fagh = (478 / 1.414) / $self->{ph};
    my $fag = ($fagh < $fagw) ? $fagh : $fagw;
    my $trx = 2860; #Verschiebung x
    my $try = 200; #Verschiebung y
    
    my @polys = [$self->{'poly_'.$pnr}->points()];
    push @polys, [$self->{'polyorg_'.$pnr}->points()]; 
    
    my %boxes = %{$self->{'boxes_'.$pnr}};
    for my $key (keys %boxes){
        push @polys, $boxes{$key};
    }
        
    for my $p (@polys){
        my @pts = @$p;
    
        my $p0x = $pts[0]->[0] * $fag + $trx;
        my $p0y = $pts[0]->[1] * $fag + $try;
        
        my $gfx = $page->gfx;
        $gfx->linewidth(2);
        $gfx->move($p0x,$p0y);
        
        for (my $i = 1; $i <= $#pts; $i++){
            my $px = $pts[$i]->[0] * $fag + $trx;
            my $py = $pts[$i]->[1] * $fag + $try;
            $gfx->line($px, $py);
        }
        $gfx->stroke();
    }
    
    for my $key (keys %boxes){
        my $hp = $self->{'zng_'.$key};
       
        
        my $p0x = ($boxes{$key}->[1][0] + $boxes{$key}->[3][0]) / 2 * $fag + $trx;
        my $p0y = ($boxes{$key}->[1][1] + $boxes{$key}->[3][1]) / 2 * $fag + $try;
        
        my $b = $boxes{$key}->[3][0] - $boxes{$key}->[1][0];
        my $txtfac = $b * $fag / 460 * 80; #verkleinerte Boxbreite / Plankopfbreite * Grundschriftgöße
        my $txth = ($txtfac < 24) ? $txtfac :  24;
        my $txt = $page->text;
        $txt->transform( -translate => [$p0x, $p0y]);
        $txt->font($self->{HB}, $txth);
        $txt->text_center($hp);
        $txt->stroke;
    }
   
    return $page;
}

package main;
use strict;

my $shopdwg = PPEEMS::SHOPDWG::shopdwg->new();
$shopdwg->get_list_bps();
$shopdwg->get_sizes();

$shopdwg->nest();


1;