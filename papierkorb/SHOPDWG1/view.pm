package PPEEMS::SHOPDWG1::view;
use strict;

use Tk;
use Tk::Utils::MainApp::MVC::View::Trace;
use Tk::Utils::Grid;

use Moose;
BEGIN {extends 'Patterns::MVC::View'};

has 'mw'        => (isa => 'Object',  is => 'rw', required => 0);
has 'prndat'    => (isa => 'Str',     is => 'rw', required => 0);

sub init{
    my ($self) = @_;
#frames           
    my $mw = $self->widget($self->mvcname());
    my (undef, $fl, $fr) = configGrid(
        $mw => {-row => ['640v'],
                -col => ['300v', '800vv']},
        $mw->Frame()=>{-row => ['640v'],
                       -col => ['300v'],
                       -grid => [0,0]},
        $mw->Frame()=>{-row => ['128', '300v', '32'],
                       -col => ['800v'],
                       -grid => [0,1]},
    );
    
    my ($fro, $frm, $fru) = configGrid(
        $fr->Frame()=>{-row => [qw/32 32 32 32/],
                       -col => [qw/200v 200v 200v/],
                       -grid => [0,0]},
        $fr->Frame()=>{-row => ['300v'],
                       -col => ['600v'],
                       -grid => [1,0]},
        $fr->Frame()=>{-row => ['32'],
                       -col => ['600v'],
                       -grid => [2,0]},
    );

#Buttons für Aktion
    (
        $self->{teilzng_lb},
        
        $self->{teilzng_b},
        $self->{ftp_liste_b},
        $self->{bpscsv2swd_b},
        $self->{bpscsv2apb_b},
        
        #$self->{template_sizes_b},
        $self->{ascii_list_b},
        $self->{apb_hp_zng_b},
        $self->{shop_zng_b},
        
        $self->{exit_b}
    ) = multiGrid(
        $fl  ->Scrolled('Listbox')                      => [0,0],
        
        $fro ->Button(-text => "Teilzeichnung einlesen")=> [0,0],
        $fro ->Button(-text => "ftp Liste erstellen")   => [1,0],
        $fro ->Button(-text => "swd Liste aus bps")     => [2,0],
        $fro ->Button(-text => "apb Liste aus bps")     => [3,0],
        
        #$fro ->Button(-text => "update template_sizes") => [0,2],
        $fro ->Button(-text => "ASCII Listen einlesen") => [0,2],
        $fro ->Button(-text => "APB HP Zeichnung")      => [1,2],
        $fro ->Button(-text => "HP Werkstattzeichnung") => [2,2],
        
        $fru ->Button(-text => "ende")  =>[0,0],
    );
    
#    #my $r = 0;
#    #for my $val ('bmf single', 'pdf multi'){
#    #    $fro->Radiobutton(-text => $val,
#    #                     -value => $val,
#    #                     -anchor => 'w',
#    #                     -padx => 10, 
#    #                     -variable => \$self->{rb_val},
#    #                     -command => sub {$self->set_selmode()})
#    #                    ->grid(-row => $r, -column => 1, -sticky => "nsew");
#    #    $r++;
#    #}
#   
    $self->{trace_t} = Tk::Utils::MainApp::MVC::View::Trace->new($frm);
    $self->{trace_t}    ->grid(0, 0);
    
    $self->teilzngs_holen();
    $self->{teilzng_lb}->configure(
        -scrollbars => 'e',
        -selectmode => 'extended',
        -height => 40,
        -width => 30,
        -background => 'blue',
        -foreground => 'white',
        -selectbackground => 'white'
    );
    
    $self->{teilzng_lb}->insert('end',@{$self->{teilzngs}});    
    
    $self->{teilzng_b}->configure(-command => sub{$self->do_read_teilzng()});
    $self->{ftp_liste_b}->configure(-command => sub {$self->ftp_liste()});
    $self->{bpscsv2swd_b}->configure(-command => sub {$self->do_bpscsv2swd_liste()});
    $self->{bpscsv2apb_b}->configure(-command => sub {$self->do_bpscsv2apb_liste()});
    
    $self->{apb_hp_zng_b}->configure(-command => sub{$self->do_apb_hp_zng()});
    $self->{ascii_list_b}->configure(-command => sub{$self->ascii_lists()});
    $self->{shop_zng_b}->configure(-command => sub{$self->do_shop_zng()});

    $self->{exit_b}  ->configure(-command => sub{exit});
        
}

sub teilzngs{
    my ($self, $not) = @_;
    
    $self->{teilzngs} = $not->teilzngs();
}

sub do_apb_hp_zng{
    my ($self) = @_;
    
    my @lb_inds = $self->{teilzng_lb}->curselection();
    if (defined $lb_inds[0]){
        my @selteilzngs = map {$self->{teilzng_lb}->get($_)} @lb_inds;
        
        for my $tz (@selteilzngs){
            ($tz) = $tz =~ m/\w{3}\#\d{4}-\d{2}-\d{2}\#(\S*)/
        }
        
        $self->create_apb_hp_bmfs(\@selteilzngs);
    }
    else{
        $self->{prndat} = "Erst mal was wählen\n";
        $self->{trace_t}->printtrace($self);
    }
}

sub do_shop_zng{
    my ($self) = @_;
    
    my @lb_inds = $self->{teilzng_lb}->curselection();
    if (defined $lb_inds[0]){
        my @selteilzngs = map {$self->{teilzng_lb}->get($_)} @lb_inds;
        
        for my $tz (@selteilzngs){
            ($tz) = $tz =~ m/\w{3}\#\d{4}-\d{2}-\d{2}\#(\S*)/
        }
        
        $self->shop_pdf(\@selteilzngs);
    }
    else{
        $self->{prndat} = "Erst mal was wählen\n";
        $self->{trace_t}->printtrace($self);
    }
}

sub do_read_teilzng{
    my ($self) = @_;
    
    my $vol = 'c:';
    my @dirs = ($vol,
                'dummy',
                'bmf',
                'tb_zeichnungen',
                );
    
    my $p = File::Spec->catdir(@dirs);
    my $types = [
        ['bmf-Dateien'  => '.bmf_'],
        ['alle Dateien' => '*'],
    ];
    $self->{tzps}=  $self->{teilzng_b}->getOpenFile(-initialdir => $p,
                                                    -filetypes => $types,
                                                    -multiple => 1);
    
    $self->read_teilzng($self->{tzps});
}

sub do_bpscsv2swd_liste{
    my ($self) = @_;
    
    my $vol = 'r:';
    my @dirs = ($vol,
                '090477_ps',
                'bps_stklisten',
                );
    
    my $p = File::Spec->catdir(@dirs);
    my $types = [
        ['csv-Dateien'  => '.csv'],
        ['alle Dateien' => '*'],
    ];
    $self->{bpscsv}=  $self->{bpscsv2swd_b}->getOpenFile(-initialdir => $p,
                                                    -filetypes => $types,
                                                    -multiple => 0);
    
    $self->BPSCSV_bpscsv2swd_liste($self->{bpscsv});
    
}

sub do_bpscsv2apb_liste{
    my ($self) = @_;
    
    my $vol = 'r:';
    my @dirs = ($vol,
                '090477_ps',
                );
    
    my $p = File::Spec->catdir(@dirs);
    my $types = [
        ['csv-Dateien'  => '.csv'],
        ['alle Dateien' => '*'],
    ];
    $self->{bpscsv}=  $self->{bpscsv2apb_b}->getOpenFile(-initialdir => $p,
                                                    -filetypes => $types,
                                                    -multiple => 0);
    
    $self->BPSCSV_bpscsv2apb_liste($self->{bpscsv});
    
}

sub listbox_update{
    my ($self, $not) = @_;
        
    $self->teilzngs_holen();
    $self->{teilzng_lb}->delete(0,'end');
    $self->{teilzng_lb}->insert('end',@{$self->{teilzngs}});
}
    

sub printtrace{
    my ($self, $not) = @_;
    
    $self->{prndat} = $not->{prndat};
    $self->{trace_t}->printtrace($self);
}

1;