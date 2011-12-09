package PPEEMS::SHOPDWG_1::m_shop_pdf;
use strict;
use Offlmod::offlmod;
use PPEEMS::SHOPDWG_1::m_nest;
use PDF::API2;

use Moose;

has 'offlmod'      => (isa => 'Object',   is => 'ro', required => 0);
has 'm_db'         => (isa => 'Object',   is => 'ro', required => 1);
has 'm_nest'       => (isa => 'Object',   is => 'ro', required => 0);
has 'selteilzngs'  => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'hdfile'       => (isa => 'Str',      is => 'rw', required => 0);
has 'hdtxtvars'    => (isa => 'HashRef',  is => 'rw', required => 0);
has 'pxcm'         => (isa => 'Num',      is => 'ro', required => 0);
#has 'outfilename' => (isa => 'Str',      is => 'rw', required => 0);
#has 'apbpos_act'  => (isa => 'Str',      is => 'rw', required => 0);
#has 'cube'        => (isa => 'Int',      is => 'rw', required => 0);

 
sub BUILD{
    my ($self) = @_;
    
    $self->{offlmod}  = Offlmod::offlmod->new();
    $self->{m_nest}   = PPEEMS::SHOPDWG_1::m_nest->new();
    $self->{pxcm}     = $self->{offlmod}->get_pxcm();
}
    
sub nest_pdf{
    my ($self) = @_;
    
    #teilzng Größe ermitteln und in DB schreiben
    $self->{m_db}->teilzngs($self->{selteilzngs});
    my $pdfpaths = $self->{m_db}->get_teilzng_paths();
    
    my %pdfsizes;
    for my $p (@$pdfpaths){
        my ($pw, $ph) = $self->_open_old_and_get_sizes($p);
        #Wenn Teilzeichnungshöhe kleiner als a0 dann $ph vergrößern für
        #mehr Abstand untereinander
        if ($ph <= (2382 - 2 * (15 + 10))){
            $ph += 20
        }
                
        $pdfsizes{$p}->{pw} = $pw;
        $pdfsizes{$p}->{ph} = $ph;
    }
        
    $self->{m_db}->set_sizes(\%pdfsizes, 'zz_teilzng');
    
    #stempelgröße 
    $self->{hdr} = $self->{m_db}->get_single_template($self->{hdfile});
    my ($pw, $ph) = $self->_open_old_and_get_sizes($self->{hdr}->{path});
    $self->{hdr}->{pw} = $pw;
    $self->{hdr}->{ph} = $ph;
    
    $self->{m_nest}->hdr($self->{hdr});
    
    #Teilzeichnungen nach Länge sortieren
    my @keys = sort {$pdfsizes{$a}->{pw} <=> $pdfsizes{$b}->{pw}} keys %pdfsizes;
    my $maxkey = $keys[$#keys];
    my %maxpdf;
    $maxpdf{$maxkey} = $pdfsizes{$maxkey};
    
    $self->{m_nest}->teilzngsizes(\%maxpdf);
    
    #Format für größte Teilzeichnung ermitteln
    my @a0xfrms = @{$self->{m_db}->get_frame_sizes('pdf')};
    my $maxfrm;
    for my $i (0..$#a0xfrms){
        $maxfrm = $self->{m_db}->get_single_template($a0xfrms[$i]);
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
    
    $self->{m_nest}->frm($maxfrm);
    $self->{m_nest}->teilzngsizes(\%pdfsizes);
    
    #Schachtelvorgang
    $self->{m_nest}->nest();
    my @zng = @{$self->{m_nest}->zng()};
    $self->{zng} = \@zng;
    
    #pdf zusammenstellen
    $self->_plankopf_ausfuellen();
    $self->_teilzngs_plako_auf_pdf_plazieren();
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
    
    my $tpl = $self->{m_db}->get_single_template($frm);
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
    
    return ($pw, $ph);
}

sub _plankopf_ausfuellen{
    my ($self) = @_;
    
    my $hd = PDF::API2->open($self->{hdr}->{path});
    my $page = $hd->openpage(0);
    
    $self->{HB} = $hd->corefont('Helvetica-Bold');
    
    
    my $txt = $page->text;
    my %hdtxtvars = %{$self->{hdtxtvars}};
    for my $key (sort keys %hdtxtvars){
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
sub _plankopf_setzen{
    my ($self) = @_;
    
    my $nop = $self->{pdf}->pages();
    for my $i (1..$nop){
        
        my $page = $self->{pdf}->openpage($i);
        
        my $hdf = PDF::API2->open("C:/dummy/pdf/wzheader_filled.pdf");
        my $xo = $self->{pdf}->importPageIntoForm($hdf, 0);
        
        my $hdrbox = $self->{zng}[$i - 1]{hdrbox};
        my $x = $hdrbox->[1][0];
        my $y = $hdrbox->[1][1];
    
        my $gfx = $page->gfx;
        $gfx->formimage($xo, $x, $y, 1);
        
        #outlines
        my $otl_pk = $self->{otls}->{'blatt_'.$i}->outline();
        $otl_pk->title('plankopf');
        $otl_pk->dest($page, -fitr => [$hdrbox->[1][0],
                                        $hdrbox->[1][1],
                                        $hdrbox->[3][0],
                                        842]);#$hdrbox->[3][1]]);
    }
}
1;