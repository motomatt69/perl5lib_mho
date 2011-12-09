package PPEEMS::SHOPDWG1::c_shop_pdf;
use strict;
use Offlmod::offlmod;
use PPEEMS::SHOPDWG1::m_nest;
use PDF::API2;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

has 'offlmod'      => (isa => 'Object',   is => 'ro', required => 0);
#has 'm_db'         => (isa => 'Object',   is => 'ro', required => 1);
has 'm_nest'       => (isa => 'Object',   is => 'ro', required => 0);
#has 'selteilzngs'  => (isa => 'ArrayRef', is => 'rw', required => 0);
#has 'hdfile'       => (isa => 'Str',      is => 'rw', required => 0);
#has 'hdtxtvars'    => (isa => 'HashRef',  is => 'rw', required => 0);
has 'pxcm'         => (isa => 'Num',      is => 'ro', required => 0);
#has 'outfilename' => (isa => 'Str',      is => 'rw', required => 0);
#has 'apbpos_act'  => (isa => 'Str',      is => 'rw', required => 0);
#has 'cube'        => (isa => 'Int',      is => 'rw', required => 0);

 
sub BUILD{
    my ($self) = @_;
    
    $self->{offlmod}  = Offlmod::offlmod->new();
    $self->{m_nest}   = PPEEMS::SHOPDWG1::m_nest->new();
    $self->{pxcm}     = $self->{offlmod}->get_pxcm();
}

sub shop_pdf{
    my ($self, $selteilzngs) = @_;
    
    my @selteilzngs = @$selteilzngs;
    map {$_ =~ s/bmf_/pdf/} @selteilzngs;
    $self->{selteilzngs} = (\@selteilzngs);
    
    my ($anr, $headernr) = ('090477', 2);
    
    $self->get_wzdata();
    my %wzdata = %{$self->zdata()};
    
    $self->get_header_headertexts($anr, $headernr);
    $self->{hdfile} = $self->hdfile();
    $self->{hdtxtvars} =$self->hdtxtvars();
    
    $self->printtrace("Plankopfinfo eingelesen\n");
    
    $self->_nest_pdf();
    
    $self->printtrace("Werkstattzeichnung geschachtelt\n");
}
    
sub _nest_pdf{
    my ($self) = @_;
    
    #teilzng Pfade holen
    $self->teilzngs($self->{selteilzngs});
    my @pdfpaths = @{$self->get_teilzng_paths()};
    
    # Teilzeichnungen mit mehreren Blättern ermitteln
    my %anzblatt;
    for my $p (@pdfpaths){
        my ($zng) = $p =~ m/(\d{6}0\d{5})/;
        $anzblatt{$zng} ++
    }
    #'Multiblätter'
    my @sorted_multiblatt;
    my @multiblatt = sort (grep{$anzblatt{$_} > 1} keys %anzblatt);
    for my $mb (@multiblatt){
        push @sorted_multiblatt, (sort (grep{$_ =~ m/$mb/} @pdfpaths));
    }
    #Singleblätter
    my @sorted_singleblatts;
    my @singleblatts = sort (grep{$anzblatt{$_} == 1} keys %anzblatt);
    for my $sb (@singleblatts){
        push @sorted_singleblatts, (sort (grep{$_ =~ m/$sb/} @pdfpaths));
    }
    
    #stempelgröße ermitteln und übergeben 
    $self->{hdr} = $self->get_single_template($self->{hdfile});
    my ($pw, $ph) = $self->_open_old_and_get_sizes($self->{hdr}->{path});
    $self->{hdr}->{pw} = $pw;
    $self->{hdr}->{ph} = $ph;
    
    $self->{m_nest}->hdr($self->{hdr});
    
    my @zng;
    #Multiblattverarbeitung
    for my $p (@sorted_multiblatt){
        my ($pw, $ph) = $self->_open_old_and_get_sizes($p);
        
        my %pdfsize;
        $pdfsize{$p}->{pw} = $pw;
        $pdfsize{$p}->{ph} = $ph;
        
        $self->{m_nest}->teilzngsizes(\%pdfsize);
        my $frm = $self->_rahmenformat_ermitteln();
        
        $self->{m_nest}->frm($frm);
        #Schachtelvorgang
        $self->{m_nest}->nest();
        push @zng, (@{$self->{m_nest}->zng()});       
    }

    #Restliche Zeichnungen
    if (@sorted_singleblatts){
        my %pdfsizes;
        for my $p (@sorted_singleblatts){
            my ($pw, $ph) = $self->_open_old_and_get_sizes($p);
            
            $pdfsizes{$p}->{pw} = $pw;
            $pdfsizes{$p}->{ph} = $ph;
        }
            
        #Teilzeichnungen nach Länge sortieren
        my @keys = sort {$pdfsizes{$a}->{pw} <=> $pdfsizes{$b}->{pw}} keys %pdfsizes;
        my $maxkey = $keys[$#keys];
        my %maxpdf;
        $maxpdf{$maxkey} = $pdfsizes{$maxkey};
        
        $self->{m_nest}->teilzngsizes(\%maxpdf);
        my $frm = $self->_rahmenformat_ermitteln();
        $self->{m_nest}->frm($frm);
        $self->{m_nest}->teilzngsizes(\%pdfsizes);
        
        #Schachtelvorgang
        $self->{m_nest}->nest();
        push @zng, (@{$self->{m_nest}->zng()});
    }
    $self->{zng} = \@zng;

    #pdf zusammenstellen
    $self->_teilzngs_plako_auf_pdf_plazieren();
}

sub _rahmenformat_ermitteln{
    my ($self) = @_;
    
    my @a0xfrms = @{$self->get_frame_sizes('pdf')};
    my $maxfrm;
    for my $i (0..$#a0xfrms){
        $maxfrm = $self->get_single_template($a0xfrms[$i]);
        my ($pw, $ph) = $self->_open_old_and_get_sizes($maxfrm->{path});
        $maxfrm->{pw} = $pw;
        $maxfrm->{ph} = $ph;
        $self->{m_nest}->frm($maxfrm);
        my $nest = $self->{m_nest}->nest();
        
        if ($nest == 1) {
            last
            }
        
        if ($i == $#a0xfrms) {
            print "Teilzeichnung zu groß für vorhandene Vorlagen\n";
            return;
        }
    }
    return $maxfrm
}

sub _teilzngs_plako_auf_pdf_plazieren{
    my ($self) = @_;
    
    my $pdf = PDF::API2->new();
    $self->{pdf} = $pdf;
    $self->{otls} = $pdf->outlines();
    
    $self->_frames_einlesen_und_teilzeichnungen_plazieren_mit_outlines();
    
    #header plazieren
    $self->_plankopf_setzen();
    
    $self->{pdf}->saveas('c:/dummy/pdf/shop1.pdf');
    print "fertig\n";
}

sub _frames_einlesen_und_teilzeichnungen_plazieren_mit_outlines{
    my ($self) = @_;
    
    for my $blatt (@{$self->{zng}}){
        my $frm = $blatt->{frm};
        $self->_newpage($frm);
        my $nop = $self->{pdf}->pages();
        my $page = $self->{pdf}->openpage($nop);
        
        my %boxes = %{$blatt->{boxes}};
        for my $key (keys %boxes){
            my $box = $boxes{$key};
            my $tzn = $blatt->{teilzngs}{$key};
            $self->_import_teilzeichnung($page, $box, $tzn);
            $self->_teilzeichnungsrahmen($page, $box);
        }
    }
}

sub _import_teilzeichnung{
    my ($self, $page, $box, $tzn) = @_;
    
    my $old = PDF::API2->open($tzn);
    my $xo = $self->{pdf}->importPageIntoForm($old, 0);
    
    my $x = $box->[1][0];
    my $y = $box->[1][1];
    
    my $gfx = $page->gfx;
    $gfx->formimage($xo, $x, $y, 1);
    
    #outlines
    my ($v, $dirs, $f) = File::Spec->splitpath($tzn);
    my ($tznr) = $f =~ m/(.*)\./;
    
    my $nop = $self->{pdf}->pages();
    my $otl_znr = $self->{otls}->{'blatt_'.$nop}->outline();
    $otl_znr->title($tznr);
    $otl_znr->dest($page, -fitr => [$box->[1][0],
                                    $box->[1][1],
                                    $box->[3][0],
                                    $box->[3][1]]);
    
}

sub _teilzeichnungsrahmen{
    my ($self, $page, $box) = @_;
    
    my @pts = @$box;
    my $p0x = $pts[0]->[0];
    my $p0y = $pts[0]->[1];
    
    my $gfx = $page->gfx;
    $gfx->linewidth(1);
    $gfx->strokecolor("#1A701A");
    $gfx->move($p0x,$p0y);
    
    for (my $i = 1; $i <= $#pts; $i++){
        my $px = $pts[$i]->[0];
        my $py = $pts[$i]->[1];
        $gfx->line($px, $py);
    }
    $gfx->stroke();
}

sub _newpage{
    my ($self, $frm) = @_;
    
    my $tpl = $self->get_single_template($frm);
    my $old = PDF::API2->open($tpl->{path});
    $self->{pdf}->importpage($old, 0);
    
    #outlines
    my $nop = $self->{pdf}->pages();
    my $page = $self->{pdf}->openpage($nop);
    
    $self->{otls}->{'blatt_'.$nop} = $self->{otls}->outline();
    $self->{otls}->{'blatt_'.$nop}->title("Blatt $nop");
    $self->{otls}->{'blatt_'.$nop}->dest($page, -fit => 1);
}

sub _open_old_and_get_sizes(){
    my ($self, $p) = @_;
    
    my $old = PDF::API2->open($p);
    my $pageold = $old->openpage(0);
    
    my ($llx, $lly, $urx, $ury) = $pageold->get_mediabox();
    my $pw = $urx - $llx;
    my $ph = $ury - $lly;
    
    #Wenn Teilzeichnungshöhe kleiner als a0 dann $ph vergrößern für
        #mehr Abstand untereinander
        if ($ph <= (2382 - 2 * (15 + 10))){
            $ph += 20
        }
        
    return ($pw, $ph);
}

sub _plankopf_setzen{
    my ($self) = @_;
    
    
    my $nop = $self->{pdf}->pages();
    for my $n (1..$nop){
        
        $self->printtrace("Blatt $n in Arbeit\n");
        
        my $page = $self->{pdf}->openpage($n);
        
        $self->_plankopf_ausfuellen($n, $nop);
    
        my $hdf = PDF::API2->open("C:/dummy/pdf/wzheader_filled.pdf");
        my $xo = $self->{pdf}->importPageIntoForm($hdf, 0);
        
        my $hdrbox = $self->{zng}[$n - 1]{hdrbox};
        my $x = $hdrbox->[1][0];
        my $y = $hdrbox->[1][1];
    
        my $gfx = $page->gfx;
        $gfx->formimage($xo, $x, $y, 1);
        
        #outlines
        my $otl_pk = $self->{otls}->{'blatt_'.$n}->outline();
        $otl_pk->title('plankopf');
        $otl_pk->dest($page, -fitr => [$hdrbox->[1][0],
                                        $hdrbox->[1][1],
                                        $hdrbox->[3][0],
                                        842]);#$hdrbox->[3][1]]);
    }
}


sub _plankopf_ausfuellen{
    my ($self, $n, $nop) = @_;
    
    my $hd = PDF::API2->open($self->{hdr}->{path});
    my $page = $hd->openpage(0);
    
    $self->{HB} = $hd->corefont('Helvetica-Bold');
    
    my %hdtxtvars = %{$self->{hdtxtvars}};
    
    my @zng = @{$self->{zng}};
    my $blatt = $zng[$n - 1];
    
    my $pw = int($blatt->{pw} / ($self->{pxcm}) *10);
    my $ph = int($blatt->{ph} / ($self->{pxcm}) *10);
    $hdtxtvars{wz_format}{val} = "$pw x $ph";
   
    $hdtxtvars{wz_blattnr}{val} = "$n von $nop";
    
    my $txt = $page->text;
    for my $key (sort keys %hdtxtvars){
        
        if ($hdtxtvars{$key}->{val} eq 'tabelle_einfuegen'){
            $self->_tabelle_einfuegen($hdtxtvars{$key}, $page, $blatt);
            next
        }
        
        my $d0x = $hdtxtvars{$key}->{d0x} * $self->{pxcm};
        my $d0y = $hdtxtvars{$key}->{d0y} * $self->{pxcm};
        my $range = $hdtxtvars{$key}->{range} * $self->{pxcm};
        
        my $txthoehe = $hdtxtvars{$key}->{hoehe};
        $txt->font($self->{HB}, $txthoehe);
        
        my $string = $hdtxtvars{$key}->{val};
        
        my $width = $txt->advancewidth($string);
        
        while ($width >= $range){
            $txthoehe --;
            $txt->font($self->{HB}, $txthoehe);
            $width = $txt->advancewidth($string);
        }
        
        $txt->textlabel($d0x, $d0y, $self->{HB}, $txthoehe, $string);
    }
    $txt->stroke;
    
    $hd->saveas("C:/dummy/pdf/wzheader_filled.pdf");
    my $dummy;
}

sub _tabelle_einfuegen{
    my ($self, $hdtxtvars, $page, $blatt) = @_;
    
    my %teilzngs = %{$blatt->{teilzngs}};
    
    my @tab;
    for my $key (sort keys %teilzngs){
        my $p = $teilzngs{$key};
        
        push @tab, (@{$self->get_apbposs2b3dpos($p)});
    }
    my @txts = map{join '  ',($_->[0], $_->[1], $_->[2])} @tab; 
    
    my $d0x = $hdtxtvars->{d0x} * $self->{pxcm};
    my $d0y = $hdtxtvars->{d0y} * $self->{pxcm};
    
    my $kozei = 'Pos     APB Pos   APB Zeichnung        ';
       
    my $txt = $page->text;   
    $txt->transform(-translate => [$d0x, $d0y]);
    $txt->font($self->{HB}, $hdtxtvars->{hoehe});
    $txt->lead(30);
    $txt->text($kozei, -underline=>[4,2]);
    for my $str (@txts){
        $txt->nl();
        $txt->text($str)
    }
    $txt->stroke;
}
1;