package PROFILE::BLTR::view;
use strict;

use Tk;
use Tk::HList;
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
           
    my $mw = $self->{mw};
    my $flo = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 0, -column => 0, -sticky => "nsew");
    my $flm = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 1, -column => 0, -sticky => "nsew");
    my $flu = $mw->Frame(-background => 'grey',
                        -relief => 'groove')->grid(-row => 2, -column => 0, -sticky => "nsew");
    
    
    $self->{fr} = $mw->Frame()->grid(-row => 0, -rowspan => 3, -column => 1);
 
# Schalter für Bltr Größe    
    $self->{h_lbl} = $flo->Label(-text => "h:")->grid(-row => 1, -column => 0, -sticky => 'nsew');
    $self->{h_e} = $flo->Entry(-validate => 'focusout',
                              -vcmd => [$self, 'do_show'])->grid(-row => 1, -column => 1);
    $self->{h_e}->insert(0,0);
    
    $self->{b_lbl} = $flo->Label(-text => "b:")->grid(-row => 2, -column => 0, -sticky => 'nsew');
    $self->{b_e} = $flo->Entry(-validate => 'focusout',
                              -vcmd => [$self, 'do_show'])->grid(-row => 2, -column => 1);
    $self->{b_e}->insert(0,0);
    
    $self->{ts_lbl} = $flo->Label(-text => "ts:")->grid(-row => 3, -column => 0, -sticky => 'nsew');
    $self->{ts_e} = $flo->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 3, -column => 1);
    $self->{ts_e}->insert(0,0);
    
    $self->{tg_lbl} = $flo->Label(-text => "tg:")->grid(-row => 4, -column => 0, -sticky => 'nsew');
    $self->{tg_e} = $flo->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 4, -column => 1);
    $self->{tg_e}->insert(0,0);
    
    $self->{aw_lbl} = $flo->Label(-text => "aw:")->grid(-row => 5, -column => 0, -sticky => 'nsew');
    $self->{aw_e} = $flo->Entry(-validate => 'focusout',
                               -vcmd => [$self, 'do_show'])->grid(-row => 5, -column => 1);
    $self->{aw_e}->insert(0,0);
 
#HList für Ral Auswahl    
    my $scry=$flm->Scrollbar();
    my $scrx=$flm->Scrollbar(-orient => "horizontal");
    $self->{ral_hlb} = $flm->HList(-columns => 3,
                                   -header => 1,
                                   -selectmode => "single",
                                   -yscrollcommand => ['set' => $scry],
                                   -xscrollcommand => ['set' => $scrx]
                                   );
    $scry->configure (-command => ['yview' => $self->{ral_hlb}]);
    $scrx->configure (-command => ['xview' => $self->{ral_hlb}]);
    $scry->pack(-side => 'right', -fill => 'y');
    $scrx->pack(-side => 'bottom', -fill => 'x');
    $self->{ral_hlb}->pack(-side => 'left', -fill => 'both');
    
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
    
    $self->{canv_h} = 500;
    $self->{canv_b} = $self->{canv_h} / sqrt(2);
        
    $self->{cs_canv} = $self->{fr}->Canvas(-background => 'white',
                                           -height => $self->{canv_h},
                                           -width => $self->{canv_b},
                                           )->pack();
    
    $self->canv_einrichten();
    
#Buttons für Aktion
    my $zeigen_b = $flu ->Button(-text => "zeigen") ->grid(-row => 0, -column => 0, -sticky => "nsew");
    my $print_b = $flu ->Button(-text => "drucken") ->grid(-row => 0, -column => 1, -sticky => "nsew");
    my $pdf_save_b = $flu ->Button(-text => "pdf save") ->grid(-row => 1, -column => 0, -sticky => "nsew");
    my $exit_b = $flu ->Button(-text => "ende")->grid(-row => 1, -column => 1, -sticky => "nsew");

    $zeigen_b->configure(-command => sub{$self->do_show()});
    $print_b->configure(-command => sub{$self->do_print()});
    $pdf_save_b->configure(-command => sub{$self->do_pdf_save()});
    $exit_b->configure(-command => sub{$self->do_exit()}); 
    $zeigen_b->focus();    
}



sub do_show{
    my ($self) = @_;
           
    $self->{h} = $self->{h_e}->get();
    $self->{b} = $self->{b_e}->get();
    $self->{ts} = $self->{ts_e}->get();
    $self->{tg} = $self->{tg_e}->get();
    $self->{aw} = $self->{aw_e}->get();
    my @size = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{aw});
    $self->{size} = \@size;
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
    
    $self->{cs_canv}->postscript( -file=>'c:\dummy\bltr.ps',
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
    
    $self->{h_e}->configure(-foreground => $self->{h_e_color});
    $self->{b_e}->configure(-foreground => $self->{b_e_color});
    $self->{ts_e}->configure(-foreground => $self->{ts_e_color});
    $self->{tg_e}->configure(-foreground => $self->{tg_e_color});
    $self->{aw_e}->configure(-foreground => $self->{aw_e_color});
    
    $self->{cs_canv}->delete("neuz");
}

sub canv_einrichten{
    my ($self) = @_;
    
    my ($rand_w, $rand_e, $rand_n, $rand_s) = (25 , 10, 10, 10);
    
    my $rahmen_rec = $self->{cs_canv}->createRectangle($rand_w,
                                                       $rand_n,
                                                       $self->{canv_b} - $rand_e,
                                                       $self->{canv_h} - $rand_s);
    
    my $kozei1 = $self->{cs_canv}->createRectangle($rand_w,
                                                   $rand_n,
                                                   $self->{canv_b} - $rand_e,
                                                   $rand_n + 20);
    
    my $kozei2 = $self->{cs_canv}->createRectangle($rand_w,
                                                   $rand_n + 20,
                                                   $self->{canv_b} - $rand_e,
                                                   $rand_n + 30,
                                                   -fill => '#00877F');
    
    my $kozeitxt1 =$self->{cs_canv}->createText($rand_w + 5,
                                               $rand_n + 18,
                                               -text => 'Blechträger',
                                               -anchor => "sw",
                                               -font => "Arial 10 normal");
}

sub cs_canv_aktu{
    my ($self) = @_;
    my $cs_canv = $self->{cs_canv};
    my $cs_canv_data_ref = $self->{canv_data_ref};
    $self->{g} = $cs_canv_data_ref->{'g'};
    $self->{u} = $cs_canv_data_ref->{'u'};
    
    my $bez_txt = $cs_canv->createText(10, 20, -text => "$self->{bez}  G= $self->{g}kg/m   U= $self->{u}m²/m",
                                               -font => "Arial 12 normal",
                                               -anchor => "w",
                                               -tags => 'neuz',);
 
    
    my $plates_ref = $cs_canv_data_ref->{'plates'};

    foreach my $plate (@$plates_ref) {
               $plate = $cs_canv->createPolygon(@$plate,
                                            -fill => $self->{hexastr},
                                            -outline => 'black',
                                            -width => 2,
                                            -tags => 'neuz',
                                            );
    }

    my $snaht_ref = $cs_canv_data_ref->{'snaht'};

    foreach my $snaht (@$snaht_ref){
               $snaht = $cs_canv->createPolygon(@$snaht,
                                               -fill => 'red4',
                                               -outline => 'black',
                                               -width => 1,
                                               -tags => 'neuz',);
    }

    my $dimlinetxt_ref = $cs_canv_data_ref->{'dimlinetxt'};
    my $dimlines_ref = $dimlinetxt_ref->[0]; 
    my $dimtxt_ref = $dimlinetxt_ref->[1];

    foreach my $dimline (@$dimlines_ref){
               $dimline = $cs_canv->createLine(@$dimline,
                                        -arrow => 'last',
                                         -tags => 'neuz',);
    }

    foreach my $dimtxt (@$dimtxt_ref){
        my $txt = shift @$dimtxt;
        $txt = $cs_canv->createText(@$dimtxt,
                                   -text => $txt,
                                   -tags => 'neuz',);
    }

    my ($syslines_ref) = $cs_canv_data_ref->{'sys'};

    foreach my $sysline (@$syslines_ref){
               $sysline = $cs_canv->createLine(@$sysline,
                                               -fill => 'grey', 
                                               -tags => 'neuz',);
    }
}    

sub get_entry_size {
	my ($self) = @_;
	return $self->{size}
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
    
sub recieveMessage {
    my ($self, $notifier, $message) = @_;
    
    if ($notifier =~ m/m_cro/){
        $self->{canv_data_ref} = $message;
    }
}

1;