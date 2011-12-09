package STATIK::CROSEC::v_crosec;
use strict;

use Tk;

use Tk::BrowseEntry;
use Tk::ItemStyle;
use Tk::Utils::Grid;

use Moose;
BEGIN {extends 'Patterns::MVC::View'};

has hexastr => (isa => 'Str', is => 'rw');

has e_vals      => (isa => 'HashRef', is => 'rw', trigger => \&_e_vals_zuordnen);
has size        => (isa => 'HashRef', is => 'rw');
has sketch_size => (isa => 'HashRef',  is => 'rw');

has canv     => (isa => 'Object', is => 'rw');
has canv_h   => (isa => 'Int', is => 'ro', default => '817');
has canv_w   => (isa => 'Int', is => 'ro', default => '578');

has be_reihe => (isa => 'Object', is => 'rw');
has be_hoehe => (isa => 'Object', is => 'rw');

has prof_entries => (isa => 'ArrayRef', is => 'rw', auto_deref => 1,
                     default => sub{[('e_h', 'e_b', 'e_ts', 'e_tg', 'e_r')]});

has e_h   => (isa => 'Object', is => 'rw');
has e_b   => (isa => 'Object', is => 'rw');
has e_ts  => (isa => 'Object', is => 'rw');
has e_tg  => (isa => 'Object', is => 'rw');
has e_r   => (isa => 'Object', is => 'rw');

#has reihe => (isa => 'Str', is => 'rw');
has sketch_size => (isa => 'HashRef', is => 'rw', default => sub{{sk_h => 450,      sk_b => 450,
                                                                  sk_startx => 300, sk_starty => 360}});
sub _e_vals_zuordnen{
    my ($self) = @_;
    
    my %e_vals = %{$self->e_vals()};
    $self->hexastr($e_vals{hexastr});
    #$self->reihe($e_vals{reihe});
    $self->size({h  => $e_vals{h},
                 b  => $e_vals{b},
                 ts => $e_vals{ts},
                 tg => $e_vals{tg},
                 r  => $e_vals{r},
                 });
}

sub init{
    my ($self) = @_;
   
    my $mw = $self->widget($self->mvcname());
    my ($fl, $flo, $flm, $flu, $fr);
    
    configGrid(
        $mw => {
            -name => 'MW',  -row  => [qw(16 400v 16)],  -col  => [qw(16 128 576v 16)],
        },
        
        {MW => 'Frame'} => {-name => 'FL',     -row  => [qw(100 400v 36)],    -col  => [qw(128)],
                            -grid => [1, 1],    -variable => \$fl,
        },
        
            {FL => 'Frame'} => {-name => 'FLO',    -row  => [qw(12 12 12 12
                                                                12 12 12 12)],    -col  => [qw(32 96)],
                                -grid => [0, 0],    -variable => \$flo,
            },
                {FLO => 'Label'} => {-grid => [0, 0], -options => [('-text', "Profil:")]},
                {FLO => 'BrowseEntry'} => {-grid => [0, 1],
                                           -options => [('-choices', ['HEA', 'HEB', 'HWS', 'QWS', 'TWS'],
                                                         '-variable', \$self->{e_vals}{reihe},
                                                         '-browsecmd', [$self, '_show'],
                                                         )],
                                           -variable => \$self->{be_reihe},
                },
                
                {FLO => 'Label'} => {-grid => [1, 0], -options => [('-text', "Nennhöhe:")],},
                {'FLO' => 'BrowseEntry'} => {-grid => [1, 1],
                                            -options => [('-state', 'readonly',
                                                          '-choices', $self->{nhs},
                                                          '-variable', \$self->{e_vals}{nh},
                                                          '-browsecmd', [$self, '_show'],
                                                          )],
                                            -variable => \$self->{be_hoehe},
                },
                
                {FLO => 'Label'} => {-grid => [3, 0], -options => [('-text', "h:",)]},                                          
                {FLO => 'Entry'} => {-grid => [3, 1], -variable => \$self->{e_h}},
                
                {FLO => 'Label'} => {-grid => [4, 0], -options => [('-text', "b:",)]},                                          
                {FLO => 'Entry'} => {-grid => [4, 1], -variable => \$self->{e_b}},
                
                {FLO => 'Label'} => {-grid => [5, 0], -options => [('-text', "ts:",)]},                                          
                {FLO => 'Entry'} => {-grid => [5, 1], -variable => \$self->{e_ts}},

                {FLO => 'Label'} => {-grid => [6, 0], -options => [('-text', "tg:",)]},                                          
                {FLO => 'Entry'} => {-grid => [6, 1], -variable => \$self->{e_tg}},

                {FLO => 'Label'} => {-grid => [7, 0], -options => [('-text', "r:",)]},                                          
                {FLO => 'Entry'} => {-grid => [7, 1], -variable => \$self->{e_r}},

            {FL => 'Frame'} => {-name => 'FLM',   -row  => [qw(400v)],    -col  => [qw(128)],
                                -grid => [1, 0],    -variable => \$flm,
            },
            
            {FL => 'Frame'} => {-name => 'FLU',   -row  => [qw(12 12 12)],     -col  => [qw(64 64)],
                                -grid => [2, 0],    -variable => \$flu,
            },
                #{FLU => 'Button'} => {-grid => [0, 0],  -options => [('-text', "drucken",
                #                                                      '-command',  sub{$self->_canv2pdf('print')})]
                #},
                #{FLU => 'Button'} => {-grid => [0, 1],  -options => [('-text', "pdf anzeigen",
                #                                                      '-command',  sub{$self->_canv2pdf('show')})]
                #},
                #{FLU => 'Button'} => {-grid => [1, 0],  -options => [('-text', "Farbe wählen",
                #                                                      '-command',  sub{$self->_raise_ral_hlist()})]
                #},
                #{FLU => 'Button'} => {-grid => [1, 1],  -options => [('-text', "batch",
                #                                                      '-command',  sub{$self->do_batch()})]
                #},
                #{FLU => 'Button'} => {-grid => [2, 0],  -options => [('-text', "csv bocad3d",
                #                                                      '-command',  sub{$self->do_csv2boc3d()})]
                #},
                #{FLU => 'Button'} => {-grid => [2, 1],  -options => [('-text', "beenden",
                #                                                      '-command',  sub{exit})]
                #},
            
        {MW => 'Frame'} => {-name => 'FR',    -row  => [qw(400v)],        -col  => [qw(576v)],
                            -grid => [1, 2],    -variable => \$fr,
        },
        
            {FR => 'Canvas'} => {-name => 'CANV',
                                 -grid => [0, 0],
                                 -options => [('-background', 'white',
                                              '-height', $self->canv_h(),
                                              '-width',  $self->canv_w())],
                                 -variable => \$self->{canv},
            },
    );
    
    $self->_init_canv();
# browsentry profilauswahl
    #$self->be_reihe()->Subwidget('entry')->insert(0,$self->reihe());
    $self->be_reihe()->Subwidget('entry')->configure(-state => 'readonly',
                                                    -width => 15,
                                                    -background => 'white',
                                                   );
                
    $self->be_hoehe()->Subwidget('entry')->configure(-width => 15,
                                                     -background => 'white');
     
# Schalter für HWS Größe
    map {$self->$_()->configure(-validate => 'focusout', -vcmd => [$self, '_show']);
         $self->$_()->bind(<"Return">, [$self, '_show']),
         } $self->prof_entries();;
    
    $self->_TextinLabel_linksbuendig($mw);
    $self->_show('start');
}


sub _show{
    my ($self, $start) = @_;
    
    my %e_vals = %{$self->e_vals()};
    
    if ($start ne 'start'){      
        my %size = map{my ($bez) = $_ =~ m/e_(\w*)\Z/;
                       $bez => $self->$_()->get()} qw(e_h e_b e_ts e_tg e_r);
        $self->size(\%size);
        
        %e_vals = (%e_vals, %size);
        $self->e_vals(\%e_vals);
    }
    $self->C_CROSEC_anzeige_refresh($e_vals{reihe}, $self->size(), $self->sketch_size());
}

sub obs_valres{
    my ($self, $not) = @_;
    
    my @val_res = $not->val_res();
    my %e_colors = (h  => $val_res[1]->{h},
                    b  => $val_res[1]->{b},
                    ts => $val_res[1]->{ts},
                    tg => $val_res[1]->{tg},
                    r  => $val_res[1]->{r},
                    );
    
    $self->_update_view(\%e_colors);
}

sub obs_cs_canv_dat{
    my ($self, $not) = @_;
    
    $self->_update_canv_table($not->cs_canv_dat);
    $self->_update_canv_sketch($not->cs_canv_dat);
}


sub _canv2pdf{
    my ($self, $show_or_print) = @_;
    
    $self->C_STATIK_canv2pdf($self->canv(), $show_or_print);
}
    
#sub do_pdf_save{
#    my ($self) = @_;
#    
#    $self->_do_ps();
#    
#    my @dirs = qw(c: dummy hwspdfs);
#    
#    my $psfile = 'bltr.ps'; #postscript
#    my $inpath = File::Spec->catfile(@dirs, $psfile);
#    
#    my $pdffile = '1.pdf';
#    my $outpath = File::Spec->catfile(@dirs, $pdffile);
#    
#    my $pdf = Archiv::Postscript::Utils::ps_to_pdf($inpath, $outpath);
#    
#    system $pdf;
#    #my $pdf = MISC::convert2pdf->convert($inpath, $outpath);
   
    #my $cmd = 'C:\Programme\PDFCreator\PDFCreator.exe /IF"c:\dummy\hwspdfs\bltr.ps" /OF"c:\dummy\outfile.pdf" /DeleteIF';
    #$cmd =~ s/outfile\.pdf/test\.pdf/;
   
    #system $cmd;
   # system 'C:\Programme\PDFCreator\PDFCreator.exe /IF"c:\dummy\bltr.ps" /OF"c:\dummy\'.$self->{bez}.'.pdf'.'"'.' /DeleteIF';
#}

#sub _do_ps{
#    my ($self) = @_;
#    
#    $self->canv()->postscript( -file=>'c:\dummy\hwspdfs\bltr.ps',
#                                 - pageheight => '297m',
#                                 - pagey => '148m',
#                                 - pageanchor => "center"
#                                 );
#}
           


sub do_batch{
    my ($self) = @_;
    
    $self->{ctrl}->message('batch');
}

sub do_csv2boc3d{
    my ($self) = @_;
    
    if (!defined $self->{vals}) {return};
    
    $self->{ctrl}->message('exp_val');
}

sub _update_view{
    my ($self, $e_colors_ref) = @_;
    
    my %e_vals = %{$self->e_vals()};
    if ($e_vals{reihe} =~ m/[HWS|QWS|TWS]/){
        $self->be_hoehe()->Subwidget('entry')->delete('0','end');
    }
    #$self->be_hoehe()->configure(-choices => $self->{nhs});
    
    my %size = %{$self->size()};
    my %e_colors = %$e_colors_ref;
    
    map{my $entry = 'e_'.$_;
        $self->$entry()->delete('0','end');
        $self->$entry()->insert('0', $size{$_});
        $self->$entry()->configure(-foreground => $e_colors{$_});
        } keys %e_colors;

    $self->canv()->delete("neuz");
}

sub _init_canv{
    my ($self, @args) = @_;
    
    my $canv = $self->canv();
    
    my $mw = $self->widget($self->mvcname());
    
    my $img = $mw->Photo(-height => $self->canv_h(), -width => $self->canv_w());
    
    $img->read("C:\\dummy\\statikblatt_leer97%.gif", -shrink, -to => (0,0));
    
    $canv->createImage(1, 1, -image => $img, -anchor => 'nw');
}


sub canv_createtxt{
    my ($self, $x, $y, $bez, $txt, $dim) = @_;
    
    $self->{canv}->createText($x, $y, -text => "$bez = $txt $dim",
                                        -font => "Arial 10 normal",
                                        -anchor => "w",
                                        -tags => 'neuz',);
}

sub _update_canv_sketch{           
    my ($self, $canv_data_ref) = @_;
    
    my $canv = $self->{canv};
    
    my $plates_ref = $canv_data_ref->{'plates'};

    foreach my $plate (@$plates_ref) {
               $plate = $canv->createPolygon(@$plate,
                                            -fill => $self->hexastr(),
                                            -outline => 'black',
                                            -width => 2,
                                            -tags => 'neuz',
                                            );
    }

    my $snaht_ref = $canv_data_ref->{'snaht'};

    foreach my $snaht (@$snaht_ref){
               $snaht = $canv->createPolygon(@$snaht,
                                               -fill => 'red4',
                                               -outline => 'black',
                                               -width => 1,
                                               -tags => 'neuz',);
    }

    my $dimlinetxt_ref = $canv_data_ref->{'dimlinetxt'};
    my $dimlines_ref = $dimlinetxt_ref->[0]; 
    my $dimtxt_ref = $dimlinetxt_ref->[1];

    foreach my $dimline (@$dimlines_ref){
               $dimline = $canv->createLine(@$dimline,
                                        -arrow => 'last',
                                         -tags => 'neuz',);
    }

    foreach my $dimtxt (@$dimtxt_ref){
        my $txt = shift @$dimtxt;
        $txt = $canv->createText(@$dimtxt,
                                   -font => "Arial 11 normal",
                                   -text => $txt,
                                   -tags => 'neuz',);
    }

    my ($syslines_ref) = $canv_data_ref->{'sys'};

    foreach my $sysline (@$syslines_ref){
               $sysline = $canv->createLine(@$sysline,
                                               -fill => 'grey', 
                                               -tags => 'neuz',);
    }
}    

sub _update_canv_table{
    my ($self, $canv_data_ref) = @_;
    
    my $canv = $self->{canv};
    
    my $vals_ref = $canv_data_ref->{vals};
    my %vals = %$vals_ref;
    $self->{vals} = $vals_ref;
    $self->{bez} = $vals{bez}; #$self->{bez} wir auch zum drucken gebraucht:
    $self->{canv}->createText(50, 80, -text => $vals{bez},
                                             -font => "Arial 12 bold",
                                             -anchor => "w",
                                             -tags => 'neuz',);
    
    $self->canv_createtxt(50, 620, 'h' , $vals{h}, 'mm');
    $self->canv_createtxt(50, 640, 'b' , $vals{b}, 'mm');
    $self->canv_createtxt(50, 660, 'ts', $vals{ts}, 'mm');
    $self->canv_createtxt(50, 680, 'tg', $vals{tg}, 'mm');
    $self->canv_createtxt(50, 700, 'A' , $vals{A}, 'mm²');
    $self->canv_createtxt(50, 720, 'G' , $vals{G}, 'kg/m');
    $self->canv_createtxt(50, 740, 'U' , $vals{U}, 'm²/m');
    
    $self->canv_createtxt(200, 620, 'Iy', $vals{Iy}, 'cm4');
    $self->canv_createtxt(200, 640, 'Wy', $vals{Wy}, 'cm³');
    $self->canv_createtxt(200, 660, 'iy', $vals{iy}, 'mm');
    $self->canv_createtxt(200, 680, 'Iz', $vals{Iz}, 'cm4');
    $self->canv_createtxt(200, 700, 'Wz', $vals{Wz}, 'cm³');
    $self->canv_createtxt(200, 720, 'iz', $vals{iz}, 'mm');
    
    $self->canv_createtxt(350, 620, 'Sy,max', $vals{Sy}, 'cm³');
    $self->canv_createtxt(350, 640, 'Sz,max', $vals{Sz}, 'cm³');
    $self->canv_createtxt(350, 660, 'Syfl  ', $vals{Syfl}, 'cm³');
    $self->canv_createtxt(350, 680, 'S235: Vzd', $vals{Vzd235}, 'kN');
    $self->canv_createtxt(350, 700, 'S235:  aw', '2 x '.$vals{aw235}, 'mm');
    $self->canv_createtxt(350, 720, 'S355: Vzd', $vals{Vzd355}, 'kN');
    $self->canv_createtxt(350, 740, 'S355:  aw', '2 x '.$vals{aw355}, 'mm');
}

sub _TextinLabel_linksbuendig{
    my ($self, $mw)=@_;
    
    my @widgets1 = $mw->children();
    for my $w1 (@widgets1){
        my @widgets2 = $w1->children();
        for my $w2 (@widgets2){
            my @widgets3 = $w2->children();
            for my $w3 (@widgets3){
                my $klasse = $w3->class();
                if ($klasse =~ m/Label/i) {
                    $w3->configure(-anchor => 'w');
                }
            }
        }
    }
    return
}


#sub set_val_res{
#    my ($self, $val_res) = @_;
#    
#    my $color_ref = $val_res->[1];
#    $self->{h_e_color} = $color_ref->{h};
#    $self->{b_e_color} = $color_ref->{b};
#    $self->{ts_e_color} = $color_ref->{ts};
#    $self->{tg_e_color} = $color_ref->{tg};
#    $self->{aw_e_color} = $color_ref->{aw};
#}
    
#sub anzeigewerte{
#    my ($self, $not) = @_;
#    
#    $self->{canv_data_ref} = $not->get_cs_canv_dat();
#}

#sub anzeige_reihe{
#    my ($self, $not) = @_;
#    
#    my $rowvals = $not->get_rowvals();
#    
#    $self->{ids}= $rowvals->[0];
#    $self->{nhs}= $rowvals->[1];
#    $self->{h}  = $rowvals->[2][0];
#    $self->{b}  = $rowvals->[2][1];
#    $self->{ts} = $rowvals->[2][2];
#    $self->{tg} = $rowvals->[2][3];
#    $self->{aw} = $rowvals->[2][4];
#    
#    $self->set_size();
#}
1;