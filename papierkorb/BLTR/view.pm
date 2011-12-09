package PROFILE::CROSEC::view;
use strict;

use Tk;
use Tk::HList;
use Tk::BrowseEntry;
use Tk::ItemStyle;

sub new{
    my ($class, $mw) = @_;
    my $self = bless {}, $class;
    $self->{mw} = $mw;
       
    return $self;
}
           
sub set_controler{
    my ($self, $c) = @_;
    $self->{ctrl} = $c;
}

sub init{
    my ($self) = @_;
#frames           
    my $mw = $self->{mw};
    my $fl1 = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 0, -column => 0, -sticky => "nsew");
    my $fl2 = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 1, -column => 0, -sticky => "nsew");
    my $fl3 = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 2, -column => 0, -sticky => "nsew");
    my $fl4 = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 3, -column => 0, -sticky => "nsew");
    
    
    $self->{fr} = $mw->Frame()->grid(-row => 0, -rowspan => 4, -column => 1);
# browsentry profilauswahl
    my $reihe_ref = ['HEA', 'HEB', 'HWS'];
    
    $self->{lbl_reihe} = $fl1->Label(-text => "Profil:",
                                     )->grid(-row => 0, -column => 0, -sticky => 'nsew');
    $self->{be_reihe} = $fl1->BrowseEntry(-choices => $reihe_ref,
                                          -variable => \$self->{reihe},
                                          -browsecmd => [$self, 'do_show'])->grid(-row => 0, -column => 1, -sticky => 'nsew');
    
    $self->{be_reihe}->Subwidget('entry')->insert(0,'HWS');
    
    $self->{be_reihe}->Subwidget('entry')->configure(-state => 'readonly',
                                                     -width => 15,
                                                     -background => 'white');
    
                                                     
    $self->{lbl_hoehe}=$fl1->Label(-text => "Nennhöhe:")->grid(-row => 1, -column => 0, -sticky => 'nsew');
    $self->{be_hoehe} = $fl1->BrowseEntry(-state => 'readonly',
                                          -choices => $self->{nhs},
                                          -variable => \$self->{nh},
                                          -browsecmd => [$self, 'do_show'])->grid(-row => 1, -column => 1, -sticky => 'nsew');
    
    $self->{be_hoehe}->Subwidget('entry')->configure(-width => 15,
                                                     -background => 'white');
     
# Schalter für HWS Größe
    ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw}) = (0,0,0,0,0);

    $self->{h_lbl} = $fl2->Label(-text => "h:")->grid(-row => 1, -column => 0, -sticky => 'nsew');
    $self->{h_e} = $fl2->Entry(-validate => 'focusout',
                              -vcmd => [$self, 'do_show'])->grid(-row => 1, -column => 1);
    $self->{h_e}->insert(0,$self->{h});
    
    $self->{b_lbl} = $fl2->Label(-text => "b:")->grid(-row => 2, -column => 0, -sticky => 'nsew');
    $self->{b_e} = $fl2->Entry(-validate => 'focusout',
                              -vcmd => [$self, 'do_show'])->grid(-row => 2, -column => 1);
    $self->{b_e}->insert(0,$self->{b});
    
    $self->{ts_lbl} = $fl2->Label(-text => "ts:")->grid(-row => 3, -column => 0, -sticky => 'nsew');
    $self->{ts_e} = $fl2->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 3, -column => 1);
    $self->{ts_e}->insert(0,$self->{ts});
    
    $self->{tg_lbl} = $fl2->Label(-text => "tg:")->grid(-row => 4, -column => 0, -sticky => 'nsew');
    $self->{tg_e} = $fl2->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 4, -column => 1);
    $self->{tg_e}->insert(0,$self->{tg});
    
    $self->{aw_lbl} = $fl2->Label(-text => "aw:")->grid(-row => 5, -column => 0, -sticky => 'nsew');
    $self->{aw_e} = $fl2->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 5, -column => 1);
    $self->{aw_e}->insert(0,$self->{aw});
 
    $self->TextinLabel_linksbuendig($mw);


 
#HList für Ral Auswahl    
    my $scry=$fl3->Scrollbar();
    my $scrx=$fl3->Scrollbar(-orient => "horizontal");
    $self->{ral_hlb} = $fl3->HList(-columns => 3,
                                   -height => 30,
                                   -header => 1,
                                   -selectmode => "single",
                                   -yscrollcommand => ['set' => $scry],
                                   -xscrollcommand => ['set' => $scrx]
                                   );
    $scry->configure (-command => ['yview' => $self->{ral_hlb}]);
    $scrx->configure (-command => ['xview' => $self->{ral_hlb}]);
    $scry->pack(-side => 'right', -fill => 'y');
    $scrx->pack(-side => 'bottom', -fill => 'x');
    $self->{ral_hlb}->pack(-fill => 'both');
    #$self->{ral_hlb}->pack(-side => 'left', -fill => 'both');
    #$self->{ral_hlb}->grid(-row => 0, -column => 0, -sticky => 'nsew');
    
    $self->{ral_hlb}->headerCreate(0, -text => 'RAL-Nr');
    $self->{ral_hlb}->headerCreate(1, -text => 'Bezeichnung');
    $self->{ral_hlb}->headerCreate(2, -text => 'Vorschau');
    
    $self->{ctrl}->message('need_ral');
    my $ral_ref = $self->{ral_data};
    my @rals = @$ral_ref;
    
    foreach  my $ral (@rals) {
        $self->{ral_hlb}->add($ral->[0]);
        $self->{ral_hlb}->itemCreate($ral->[0], 0, -text => $ral->[0]);
        $self->{ral_hlb}->itemCreate($ral->[0], 1, -text => $ral->[1]);
        $self->{ral_hlb}->itemCreate($ral->[0], 2, -text => $ral->[2]);
        my $style = $self->{ral_hlb}->ItemStyle('text',
                                                -background => $ral->[2],
                                                -foreground => $ral->[2]);
        
        $self->{ral_hlb}->itemConfigure("$ral->[0]", 2, -style => $style);
    }
    
    $self->{ral_hlb}->selectionSet(1000,1000);
    $self->{ral_hlb}->bind('<ButtonRelease-1>',
                           sub{$self->do_ral()});
        
#canvas_main
    
    $self->{canv_h} = 800;
    $self->{canv_b} = $self->{canv_h} / sqrt(2);
        
    $self->{canv} = $self->{fr}->Canvas(-background => 'white',
                                           -height => $self->{canv_h},
                                           -width => $self->{canv_b},
                                           )->pack();
    
    $self->canv_einrichten();
  
#Buttons für Aktion
    my $zeigen_b = $fl4 ->Button(-text => "zeigen") ->grid(-row => 0, -column => 0, -sticky => "nsew");
    my $print_b = $fl4 ->Button(-text => "drucken") ->grid(-row => 0, -column => 1, -sticky => "nsew");
    my $pdf_save_b = $fl4 ->Button(-text => "pdf save") ->grid(-row => 1, -column => 0, -sticky => "nsew");
    my $exit_b = $fl4 ->Button(-text => "ende")->grid(-row => 1, -column => 1, -sticky => "nsew");

    $zeigen_b->configure(-command => sub{$self->do_show()});
    $print_b->configure(-command => sub{$self->do_print()});
    $pdf_save_b->configure(-command => sub{$self->do_pdf_save()});
    $exit_b->configure(-command => sub{$self->do_exit()}); 
    $zeigen_b->focus();    
}

sub TextinLabel_linksbuendig{
    my ($self, $mw)=@_;
    
    my @widgets1 = $mw->children();
    foreach my $w1 (@widgets1){
        my @widgets2 = $w1->children();
        foreach my $w2 (@widgets2){
            my $klasse = $w2->class();
            if ($klasse =~ m/Label/i) {
                $w2->configure(-anchor => 'w');
            }
        }
    }
}

sub do_show{
    my ($self) = @_;
           
    $self->{h} = $self->{h_e}->get();
    $self->{b} = $self->{b_e}->get();
    $self->{ts} = $self->{ts_e}->get();
    $self->{tg} = $self->{tg_e}->get();
    $self->{aw} = $self->{aw_e}->get();
    
    $self->set_size();
    
    $self->{bez} = 'IS '.$self->{h}.'/'.$self->{b}.'/'.$self->{ts}.'/'.$self->{tg}.'/'.$self->{aw}; 
                      
    $self->{ctrl}->message('show');
}

sub do_print{
    my ($self) = @_;
    
    $self->do_ps();
    system 'C:\Programme\PDFCreator\PDFCreator.exe /NoStart /PF"c:\dummy\bltr.ps';
    
}
    
sub do_pdf_save{
    my ($self) = @_;
    
    $self->do_ps();
    system 'C:\Programme\PDFCreator\PDFCreator.exe /IF"c:\dummy\bltr.ps" /OF"c:\dummy\bltr.pdf" /DeleteIF';
}

sub do_ps{
    my ($self) = @_;
    
    $self->{canv}->postscript( -file=>'c:\dummy\bltr.ps',
                                 - pageheight => '297m',
                                 - pagey => '148m',
                                 - pageanchor => "center"
                                 );
}
           
sub do_exit{
    my ($self) = @_;
    $self->{ctrl}->message('ende');
}

sub do_ral{
    my ($self) = @_;
    my $entry = $self->{ral_hlb}->selectionGet();
    my $hexastr = $self->{ral_hlb}->itemCget($entry,2,"text");
    $self->{hexastr} = $hexastr;
}


sub set_entrys_aktu{
    my ($self) = @_;
    
    if ($self->{reihe} eq 'HWS'){
        $self->{be_hoehe}->Subwidget('entry')->delete('0','end');
        $self->{nhs} = ();
    }
    $self->{be_hoehe}->configure(-choices => $self->{nhs});
    
    $self->{h_e}->delete('0','end');
    $self->{h_e}->insert('0',$self->{h});
    $self->{h_e}->configure(-foreground => $self->{h_e_color});
    $self->{b_e}->delete('0','end');
    $self->{b_e}->insert('0',$self->{b});
    $self->{b_e}->configure(-foreground => $self->{b_e_color});
    $self->{ts_e}->delete('0','end');
    $self->{ts_e}->insert('0',$self->{ts});
    $self->{ts_e}->configure(-foreground => $self->{ts_e_color});
    $self->{tg_e}->delete('0','end');
    $self->{tg_e}->insert('0',$self->{tg});
    $self->{tg_e}->configure(-foreground => $self->{tg_e_color});
    $self->{aw_e}->delete('0','end');
    $self->{aw_e}->insert('0',$self->{aw});
    $self->{aw_e}->configure(-foreground => $self->{aw_e_color});
    
    $self->{canv}->delete("neuz");
    $self->{canv}->delete("neuz");
}

sub canv_einrichten{
    my ($self) = @_;
 #Kopfzeilen   
    my ($rand_w, $rand_e, $rand_n, $rand_s) = (25 , 10, 10, 10);
    
    my $rahmen_rec = $self->{canv}->createRectangle($rand_w,
                                                       $rand_n,
                                                       $self->{canv_b} - $rand_e,
                                                       $self->{canv_h} - $rand_s);
    
    my $kozei1 = $self->{canv}->createRectangle($rand_w,
                                                   $rand_n,
                                                   $self->{canv_b} - $rand_e,
                                                   $rand_n + 20);
    
    my $kozei2 = $self->{canv}->createRectangle($rand_w,
                                                   $rand_n + 20,
                                                   $self->{canv_b} - $rand_e,
                                                   $rand_n + 30,
                                                   -fill => '#00877F');
    
    my $kozeitxt1 =$self->{canv}->createText($rand_w + 5,
                                               $rand_n + 18,
                                               -text => 'Blechträger',
                                               -anchor => "sw",
                                               -font => "Arial 10 normal");
#Skizzenbereich    
    my %sketch_size = (sk_h => 300,
                       sk_b => 300,
                       sk_startx => 410,
                       sk_starty => 200);

    $self->{sketch_size} = \%sketch_size;
    #$self->{sketch_b} = $self->{sketch_h};
    #$self
    
}

sub set_canv_aktu{
    my ($self) = @_;
    
    my $canv = $self->{canv};
    my $canv_data_ref = $self->{canv_data_ref};
    $self->{g} = $canv_data_ref->{'g'};
    $self->{u} = $canv_data_ref->{'u'};
    
    my $bez_txt = $canv->createText(50, 400, -text => "$self->{bez}  G= $self->{g}kg/m   U= $self->{u}m²/m",
                                               -font => "Arial 12 normal",
                                               -anchor => "w",
                                               -tags => 'neuz',);

    
    $self->sketch_aktu();
}
sub sketch_aktu{           
    my ($self) = @_;
    my $canv = $self->{canv};
    my $canv_data_ref = $self->{canv_data_ref};
 
    
    my $plates_ref = $canv_data_ref->{'plates'};

    foreach my $plate (@$plates_ref) {
               $plate = $canv->createPolygon(@$plate,
                                            -fill => $self->{hexastr},
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

sub get_entry_size {
	my ($self) = @_;
	return $self->{size}
}

sub set_size{
    my ($self) = @_;
    
    my @size = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw});
    $self->{size} = \@size;    
}

sub get_reihe {
	my ($self) = @_;
	
        return $self->{reihe}
}

sub get_nh {
	my ($self) = @_;
	
        return $self->{nh}
}

sub get_sketch_size {
    my ($self) = @_;
    
    return $self->{sketch_size}
}

sub set_ral_data {
	my ($self, $ral_data) = @_;
	$self->{ral_data} = $ral_data;
}

sub set_val_res{
    my ($self, $val_res) = @_;
    
    my $color_ref = $val_res->[1];
    $self->{h_e_color} = $color_ref->{h};
    $self->{b_e_color} = $color_ref->{b};
    $self->{ts_e_color} = $color_ref->{ts};
    $self->{tg_e_color} = $color_ref->{tg};
    $self->{aw_e_color} = $color_ref->{aw};
}
    
sub set_rowvals{
    my ($self, $rowvals) = @_;
    
    $self->{ids} = $rowvals->[0];
    $self->{nhs} = $rowvals->[1];
    $self->{h} = $rowvals->[2][0];
    $self->{b} = $rowvals->[2][1];
    $self->{ts} = $rowvals->[2][2];
    $self->{tg} = $rowvals->[2][3];
    $self->{aw} = $rowvals->[2][4];
    
    $self->set_size();
}

sub recieveMessage {
    my ($self, $notifier, $message) = @_;
    
    if ($notifier =~ m/m_cro_hws/){
        $self->{canv_data_ref} = $message;
    }
    #}elsif ($notifier =~ m/m_reihe/){
    #    $self->{ids} = $message->[0];
    #    $self->{nhs} = $message->[1];
    #    $self->{h} = $message->[2][0];
    #    $self->{b} = $message->[2][1];
    #    $self->{ts} = $message->[2][2];
    #    $self->{tg} = $message->[2][3];
    #    $self->{aw} = $message->[2][4];
}



1;