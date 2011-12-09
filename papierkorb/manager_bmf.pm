package PPEEMS::SHOPDWG::manager_bmf;
use strict;
use Offlmod::offlmod;
use PPEEMS::SHOPDWG::m_nest;

use Moose;

has 'offlmod'     => (isa => 'Object',   is => 'ro', required => 0);
has 'm_db'        => (isa => 'Object',   is => 'ro', required => 1);
has 'm_nest'      => (isa => 'Object',   is => 'ro', required => 0);
has 'selteilzngs' => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'hdbez'       => (isa => 'Str',      is => 'rw', required => 0);
has 'hdtxts'      => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'outfilename' => (isa => 'Str',      is => 'rw', required => 0);
has 'apbpos_act'  => (isa => 'Str',      is => 'rw', required => 0);
has 'cube'        => (isa => 'Int',      is => 'rw', required => 0);

 
sub BUILD{
    my ($self) = @_;
    
    $self->{offlmod}  = Offlmod::offlmod->new();
    $self->{m_nest}   = PPEEMS::SHOPDWG::m_nest->new();
}
    
sub template_sizes{
    my ($self) = @_;
    
    my $bmfpaths = $self->{m_db}->get_all_template_bmf_paths();
    
    $self->{offlmod}->bmfpaths($bmfpaths);
    my $bmfsizes = $self->{offlmod}->get_sizes();
    $self->{m_db}->set_sizes($bmfsizes, 'zz_vorlagen');  
}

sub nest_bmf{
    my ($self) = @_;
    
    #teilzng Größe ermitteln und in DB schreiben
    $self->{m_db}->teilzngs($self->{selteilzngs});
    my $bmfpaths = $self->{m_db}->get_teilzng_paths();
    $self->{offlmod}->bmfpaths($bmfpaths);
    my $bmfsizesref = $self->{offlmod}->get_sizes();
    $self->{m_db}->set_sizes($bmfsizesref, 'zz_teilzng');
    
    #stempelgröße 
    my $hdr = $self->{m_db}->get_single_template($self->{hdbez});
       
    #header und teilzngsizes in px umrechenen
    my $pxcm = $self->{offlmod}->get_pxcm();
    
    $hdr->{pw} *= $pxcm;
    $hdr->{ph} *= $pxcm;
        
    my %bmfsizes = %$bmfsizesref;
    map {$bmfsizes{$_}->{ph} *= $pxcm;
         $bmfsizes{$_}->{pw} *= $pxcm} keys %bmfsizes;
    $bmfsizesref = \%bmfsizes;
    
    #a0x frames holen
    my @a0xfrms = @{$self->{m_db}->get_frame_sizes()};
    #Schachtelvorgang
    $self->{m_nest}->hdr($hdr);
    $self->{m_nest}->teilzngsizes($bmfsizesref);
    
    for (my $i = 0; $i <= $#a0xfrms; $i++){
        my $frm = $self->{m_db}->get_single_template($a0xfrms[$i]);
        $frm->{pw} *= $pxcm;
        $frm->{ph} *= $pxcm;
        $self->{m_nest}->frm($frm);
        my $nest = $self->{m_nest}->nest();
        
        if ($nest == 1) {last}
        
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
    
    my $cnt = 1;
    #teilzngs auf bmf plazieren
    for my $blatt (@{$self->{zng}}){
        my $frm = $blatt->{frm};
        my $tpl = $self->{m_db}->get_single_template($frm);
        
        my ($v, $dirs, $f) = File::Spec->splitpath($tpl->{path});
        my $basebmf = $dirs.$f;        
        
        $blatt->{name} = '/dummy/bmf/'.$self->{outfilename};
        my $outbmf = $blatt->{name};
        
        my $bmf = Offlmod::offlmod->new(outbmf => $outbmf,
                                        basebmf => $basebmf);
        my $pxcm = $bmf->pxcm();
        
        #teilzeichnungen drauf und apbpos ersetzen
        my %teilzngs = %{$blatt->{teilzngs}};
        my %boxes = %{$blatt->{boxes}};
        
        my $tplpw = $blatt->{pw};
        my $tplph = $blatt->{ph};
        
        for my $key (sort keys %boxes){
            
            my $xl = ($boxes{$key}->[1][0]) / $pxcm;
            my $xr = ($tplpw - $boxes{$key}->[3][0]) / $pxcm;
            my $yu = ($boxes{$key}->[1][1]) / $pxcm;
            my $yo = ($tplph - $boxes{$key}->[3][1]) / $pxcm;
            
            $bmf->set_area({nr => $key,
                            xl => $xl,
                            xr => $xr,
                            yu => $yu,
                            yo => $yo,
                            #type => 0,
                            #pen => 1
                            });
            
            my ($v, $dirs, $f) = File::Spec->splitpath($teilzngs{$key});
            my $subbmf = $dirs.$f;        
            
            $subbmf = $self->_apbpos_eintragen($subbmf);
            
            $bmf->fillarea({path => $subbmf,
                            area_nr => $key,
                            anchor => 5});
        }
        
        #plankopf ausfüllen;
        $self->_fill_header($blatt);
        #plankopf drauf
        my $hd = $self->{m_db}->get_single_template($self->{hdbez});
        
        my $hdpw = $hd->{pw} * $pxcm;
        my $hdph = $hd->{ph} * $pxcm;
        
        my $xr = 14.2 / $pxcm;
        my $xl = ($tplpw - $hdpw - ($xr * $pxcm)) / $pxcm;
        my $yu = 14.2 / $pxcm;
        my $yo = ($tplph - $hdph - ($yu * $pxcm)) / $pxcm;
            
        $bmf->set_area({nr => 199,
                        xl => $xl,
                        xr => $xr,
                        yu => $yu,
                        yo => $yo,
                        #type => 0,
                        #pen => 1
                        });      
        
        my $hdfill = $self->{m_db}->get_single_template('header filled');
        ($v, $dirs, $f) = File::Spec->splitpath($hdfill->{path});
        $bmf->fillarea({path => $dirs.$f,
                        area_nr => 199,
                        anchor => 5});
        
        #Stahlgütenstempel
        my $sgs = $self->{m_db}->get_single_template('stempel stahlguete');
        
        my $sgspw = $sgs->{pw} * $pxcm;
        my $sgsph = $sgs->{ph} * $pxcm;
        
        $xr = $tplpw / $pxcm - $xl;
        $xl = ($tplpw - ($xr * $pxcm) - $sgspw) / $pxcm;
        $yu = $yu;
        $yo = ($tplph - $sgsph - ($yu * $pxcm)) / $pxcm;
            
        $bmf->set_area({nr => 198,
                        xl => $xl,
                        xr => $xr,
                        yu => $yu,
                        yo => $yo,
                        #type => 0,
                        #pen => 1
                        });      
        
        ($v, $dirs, $f) = File::Spec->splitpath($sgs->{path});
        $bmf->fillarea({path => $dirs.$f,
                        area_nr => 198,
                        anchor => 5});
        
        #$bmf->finish();
        
        #Fussleistenstempel
        my $fls = $self->{m_db}->get_single_template('stempel fussleiste');
        
        my $flspw = $fls->{pw} * $pxcm;
        my $flsph = $fls->{ph} * $pxcm;
        
        $xr = $tplpw / $pxcm - $xl;
        $xl = ($tplpw - ($xr * $pxcm) - $flspw) / $pxcm;
        $yu = $yu;
        $yo = ($tplph - $flsph - ($yu * $pxcm)) / $pxcm;
            
        $bmf->set_area({nr => 197,
                        xl => $xl,
                        xr => $xr,
                        yu => $yu,
                        yo => $yo,
                        #type => 0,
                        #pen => 1
                        });      
        
        ($v, $dirs, $f) = File::Spec->splitpath($fls->{path});
        $bmf->fillarea({path => $dirs.$f,
                        area_nr => 197,
                        anchor => 5});
        
        #$bmf->finish();
        
        #cubeskizze
        my $tplbez = 'stempel cube'.$self->{cube};
        my $csk = $self->{m_db}->get_single_template($tplbez);
        
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
        
        $cnt++;
    }
}
 
sub _fill_header{
    my ($self, $blatt) = @_;
    
    my $hd = $self->{m_db}->get_single_template($self->{hdbez});
    my ($v, $dirs, $f) = File::Spec->splitpath($hd->{path});
    my $basebmf = $dirs.$f;
    my $outbmf = '/dummy/bmf/header_filled.bmf_';
        
    my $bmf = Offlmod::offlmod->new(outbmf => $outbmf,
                                    basebmf => $basebmf);
    
    my @hdtxts = @{$self->{hdtxts}};
    for my $hdtxt (@hdtxts){       
        $bmf->set_textfit({ text =>     $hdtxt->{val},
                            x0 =>       $hdtxt->{d0x} + $hd->{d0x},
                            y0 =>       $hdtxt->{d0y} + $hd->{d0y},
                            winkel =>   $hdtxt->{winkel},
                            pen =>      $hdtxt->{stift},
                            hgt =>      $hdtxt->{hoehe},
                            hbv =>      $hdtxt->{hoehe2breite},
                            art =>      $hdtxt->{art},
                            neigw =>    $hdtxt->{neigung},
                            anchor =>   $hdtxt->{anker},
                            rahmen =>   $hdtxt->{rahmen},
                            range =>    $hdtxt->{range},
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


1;