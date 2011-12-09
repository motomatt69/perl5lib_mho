package PPEEMS::SHOPDWG1::c_apb_hp_bmf;
use strict;
use Offlmod::offlmod;
use PPEEMS::SHOPDWG1::m_nest;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

has 'offlmod'     => (isa => 'Object',   is => 'ro', required => 0);
has 'm_nest'      => (isa => 'Object',   is => 'ro', required => 0);

sub BUILD{
    my ($self) = @_;
    
    $self->{offlmod}  = Offlmod::offlmod->new();
    $self->{m_nest}   = PPEEMS::SHOPDWG1::m_nest->new();
}

sub create_apb_hp_bmfs{
    my ($self, $selteilzngs) = @_;
    
    my ($anr, $headernr) = ('090477', 1);
    
    for my $selteilzng (@$selteilzngs){
        my ($ts, $hpos, $blatt, $rev) = $selteilzng =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})\.bmf_/;    
       
        $self->get_tzdata($ts, $hpos, $blatt, $rev); #m_db
        my %tzdata = %{$self->zdata()}; #m_db
        my %apbposs = %{$tzdata{apbposs}};
               
        $self->{selteilzng} = $selteilzng;#m_db
        
        for my $key (sort keys %apbposs){
            
            $self->apbpos_act($key);#m_db
            $self->get_header_headertexts($anr, $headernr);#m_db
            
            $self->{apbpos_act} = $key;
            $self->{hdfile} = $self->hdfile();#m_db
            $self->{hdtxtvars} = $self->hdtxtvars();#m_db
            $self->printtrace("Plankopfinfo eingelesen\n");
            
            $self->{outfn} = $apbposs{$key}->{apbfn};       
         
            $self->{cube} = $tzdata{cube};
            $self->nest_bmf();
            
            $self->set_apbzng2apbpos();
            $self->set_eintrag_teilzeichnung_erstellt();
            $self->printtrace("ts: $ts  B3Dpos: ".$tzdata{zngnr}."  APBpos: ".$key."  APBzng: ".$self->{outfn}."\n");
        }
    }
}     

sub nest_bmf{
    my ($self) = @_;
    
    #teilzng Größe ermitteln und in DB schreiben
    my $selteilzngs->[0] = $self->{selteilzng};
    $self->teilzngs($selteilzngs);#m_db
    my $bmfpaths = $self->get_teilzng_paths();#m_db
    $self->{offlmod}->bmfpaths($bmfpaths);
    my $bmfsizesref = $self->{offlmod}->get_sizes();
    $self->set_sizes($bmfsizesref, 'zz_teilzng');
    
    #stempelgröße 
    my $hdr = $self->_calc_template_sizes($self->{hdfile});
       
    #header und teilzngsizes in px umrechenen
    my $pxcm = $self->{offlmod}->get_pxcm();
    
    $hdr->{pw} *= $pxcm;
    $hdr->{ph} *= $pxcm;
        
    my %bmfsizes = %$bmfsizesref;
    map {$bmfsizes{$_}->{ph} *= $pxcm;
         $bmfsizes{$_}->{pw} *= $pxcm} keys %bmfsizes;
    $bmfsizesref = \%bmfsizes;
    
    #a0x frames holen
    my @a0xfrms = @{$self->get_frame_sizes('bmf_')};
    #Schachtelvorgang
    $self->{m_nest}->hdr($hdr);
    $self->{m_nest}->teilzngsizes($bmfsizesref);
    
    for my $i (0..$#a0xfrms){
        my $frm = $self->_calc_template_sizes($a0xfrms[$i]);
        $frm->{pw} *= $pxcm;
        $frm->{ph} *= $pxcm;
        $self->{m_nest}->frm($frm);
        my $nest = $self->{m_nest}->nest();
        
        if ($nest == 1) {
            print "Rahmenformat: $a0xfrms[$i]\n";
                if ($a0xfrms[$i] eq 'frame_a00.bmf_'){
                    $self->{hdtxtvars}{apb_format}{val} = '00'
                }
                else{
                    $self->{hdtxtvars}{apb_format}{val} = '09'
                }
            last}
        
        if ($i == $#a0xfrms) {
            print "Teilzeichnung zu groß für vorhandene Vorlagen\n";
            return;
        }
    }
    my @zng = @{$self->{m_nest}->zng()};
    $self->{zng} = \@zng;
    
    #bmf zusammenstellen
    $self->_teilzngs_plako_auf_bmf_plazieren();
}

sub _teilzngs_plako_auf_bmf_plazieren{
    my ($self) = @_;
    
    #teilzngs auf bmf plazieren
    my @zng = @{$self->{zng}};
    my $blatt = $zng[0];
    my $frm = $blatt->{frm};
    my $tpl = $self->_calc_template_sizes($frm);
    
    my ($v, $dirs, $f) = File::Spec->splitpath($tpl->{path});
    my $basebmf = $dirs.$f;        
    
    my $outpath = $self->{zng}[0]{teilzngs}{1};
    my ($v_out, $dirs_out, $f_out) = File::Spec->splitpath($outpath);
    $dirs_out .= 'apb/';
    $blatt->{name} = $dirs_out.$self->{outfn};
    my $outbmf = $blatt->{name};
    
    my $bmf = Offlmod::offlmod->new(outbmf => $outbmf,
                                    basebmf => $basebmf);
    my $pxcm = $bmf->pxcm();
    
    #teilzeichnung drauf und apbpos ersetzen
    my %teilzngs = %{$blatt->{teilzngs}};
    my %boxes = %{$blatt->{boxes}};
    my $box = $boxes{1};
    
    my $tplpw = $blatt->{pw};
    my $tplph = $blatt->{ph};
    
    #Teilzeichnung wird mittig plaziert
    my $hdrbox = $blatt->{hdrbox};
    my $xl = ($box->[1][0]) / $pxcm;
    my $xr = ($tplpw - $hdrbox->[1][0]) / $pxcm;
    my $yu = ($hdrbox->[1][1]) / $pxcm;
    my $yo = ($tplph - $box->[3][1]) / $pxcm;
    
    $bmf->set_area({nr => 1,
                    xl => $xl,
                    xr => $xr,
                    yu => $yu,
                    yo => $yo,
                    #type => 0,
                    #pen => 1
                    });
    
    ($v, $dirs, $f) = File::Spec->splitpath($teilzngs{1});
    my $subbmf = $dirs.$f;        
    
    $subbmf = $self->_apbpos_eintragen($subbmf);
    
    $bmf->fillarea({path => $subbmf,
                    area_nr => 1,
                    anchor => 5});

    #plankopf ausfüllen;
    $self->_fill_header($blatt);
    #plankopf drauf
    my $hd = $self->_calc_template_sizes($self->{hdfile});
    
    my $hdpw = $hd->{pw} * $pxcm;
    my $hdph = $hd->{ph} * $pxcm;
    
    
    $xr = ($tplpw - $hdrbox->[3][0]) / $pxcm;
    $xl = ($hdrbox->[1][0]) / $pxcm;
    $yu = ($hdrbox->[2][1]) / $pxcm;
    $yo = ($tplph - $hdrbox->[3][1]) / $pxcm;

    $bmf->set_area({nr => 199,
                    xl => $xl,
                    xr => $xr,
                    yu => $yu,
                    yo => $yo,
                    #type => 0,
                    #pen => 3
                    });      
    
    my $hdfill = $self->_calc_template_sizes('apbheader_filled.bmf_');
    ($v, $dirs, $f) = File::Spec->splitpath($hdfill->{path});
    $bmf->fillarea({path => $dirs.$f,
                    area_nr => 199,
                    anchor => 5});
    
    #cubeskizze
    my $tplbez = 'stempel_cube_'.$self->{cube}.'.bmf_';
    my $csk = $self->_calc_template_sizes($tplbez);
    
    my $cskpw = $csk->{pw} * $pxcm;
    my $cskph = $csk->{ph} * $pxcm;
    
    $xr = 60 / $pxcm;
    $xl = ($tplpw - $cskpw - ($xr * $pxcm)) / $pxcm;
    $yu = 924 / $pxcm;
    $yo = ($tplph - $cskph - ($yu * $pxcm)) / $pxcm;
        
    $bmf->set_area({nr => 196,
                    xl => $xl,
                    xr => $xr,
                    yu => $yu,
                    yo => $yo,
                    #type => 0,
                    #pen => 1
                    });      
    
    ($v, $dirs, $f) = File::Spec->splitpath($csk->{path});
    $bmf->fillarea({path => $dirs.$f,
                    area_nr => 196,
                    anchor => 5});
    
    $bmf->finish();
}
 
sub _fill_header{
    my ($self, $blatt) = @_;
    
    my $hd = $self->_calc_template_sizes($self->{hdfile});
    my ($v, $dirs, $f) = File::Spec->splitpath($hd->{path});
    my $basebmf = $dirs.$f;
    my $outbmf = '/dummy/bmf/apbheader_filled.bmf_';
        
    my $bmf = Offlmod::offlmod->new(outbmf => $outbmf,
                                    basebmf => $basebmf);
    
    my %hdtxtvars = %{$self->{hdtxtvars}};
    for my $key (sort keys %hdtxtvars){       
        $bmf->set_textfit({ text =>     $hdtxtvars{$key}->{val},
                            x0 =>       $hdtxtvars{$key}->{d0x} + $hd->{d0x},
                            y0 =>       $hdtxtvars{$key}->{d0y} + $hd->{d0y},
                            winkel =>   $hdtxtvars{$key}->{winkel},
                            pen =>      $hdtxtvars{$key}->{stift},
                            hgt =>      $hdtxtvars{$key}->{hoehe},
                            hbv =>      $hdtxtvars{$key}->{hoehe2breite},
                            art =>      $hdtxtvars{$key}->{art},
                            neigw =>    $hdtxtvars{$key}->{neigung},
                            anchor =>   $hdtxtvars{$key}->{anker},
                            rahmen =>   $hdtxtvars{$key}->{rahmen},
                            range =>    $hdtxtvars{$key}->{range},
                        });
    }
    
    $bmf->finish;
}

sub _apbpos_eintragen{
    my($self, $subbmf) = @_;
    
    my $basebmf = $subbmf;
    my $outbmf = '/dummy/bmf/subbmf_filled.bmf_';
        
    my $bmf = Offlmod::offlmod->new(outbmf => $outbmf,
                                    basebmf => $basebmf);
    
    my $apbpos_act = $self->{apbpos_act};
    my ($apb1, $apb2) = $apbpos_act =~ m/(\d{4})(\d{4})/;
    $apbpos_act = $apb1.'-'.$apb2;
    
    $bmf->set_replace_text({sgtyp => 9279300,#Stücklistentext
                        minnc => 1,
                        maxnc => 10,
                        key => 2,
                        such => '\d{4}-\d{4}',
                        ersetze => '\d{4}-\d{4}',
                        mit => $apbpos_act,
                        });
    
    $bmf->set_replace_text({sgtyp => 4991300,#Hauptpostext
                        minnc => 1,
                        maxnc => 300,
                        key => 2,
                        such => '\d{4}-\d{4}',
                        ersetze => '\d{4}-\d{4}',
                        mit => $apbpos_act,
                        });
    
    $bmf->set_replace_text({sgtyp => 3999300, #Einzelteiltext
                        minnc => 1,
                        maxnc => 300,
                        key => 2,
                        such => '\d{4}-\d{4}',
                        ersetze => '\d{4}-\d{4}',
                        mit => $apbpos_act,
                        });
    $bmf->finish;
    
    return $outbmf;
}

    
sub _calc_template_sizes{
    my ($self, $tpl) = @_;
    
    my $tpldat = $self->get_single_template($tpl);
    my $bmfpath->[0] = $tpldat->{path};
    $self->{offlmod}->bmfpaths($bmfpath);
    my %bmfsizes = %{$self->{offlmod}->get_sizes()};
    
    $tpldat->{d0x} = $bmfsizes{$tpldat->{path}}->{d0x};
    $tpldat->{d0y} = $bmfsizes{$tpldat->{path}}->{d0y};
    $tpldat->{pw} = $bmfsizes{$tpldat->{path}}->{pw};
    $tpldat->{ph} = $bmfsizes{$tpldat->{path}}->{ph};
    
    return $tpldat;
}

1;