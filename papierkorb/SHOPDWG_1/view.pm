package PPEEMS::SHOPDWG_1::view;
use strict;

use Tk;
use Patterns::Observer qw(:observer);
use Tk::Utils::MainApp::MVC::View::Trace;
use Tk::Utils::Grid;

use Moose;

has 'mw'        => (isa => 'Object',  is => 'rw', required => 1);
has 'controler' => (isa => 'Object',  is => 'rw', required => 0);
has 'prndat'    => (isa => 'Str',     is => 'rw', required => 0);
has 'cdwgs'     => (isa => 'Str',     is => 'ro', required => 0);
has 'rb_val'    => (isa => 'Str',     is => 'ro', required => 0, default => "bmf single");
has 'zngtype'   => (isa => 'Str',     is => 'ro', required => 0, default => "bmf");
has 'tzps'      => (isa => 'ArrayRef',is => 'ro', required => 0);

sub init{
    my ($self) = @_;
#frames           
    my $mw = $self->{mw};
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
        
        $self->{template_sizes_b},
        $self->{ascii_list_b},
        $self->{apb_hp_zng_b},
        $self->{shop_zng_b},
        
        $self->{exit_b}
    ) = multiGrid(
        $fl  ->Scrolled('Listbox')                      => [0,0],
        
        $fro ->Button(-text => "Teilzeichnung einlesen")=> [0,0],
        $fro ->Button(-text => "ftp Liste erstellen")   => [1,0],
        
        $fro ->Button(-text => "update template_sizes") => [0,2],
        $fro ->Button(-text => "ASCII Listen einlesen") => [1,2],
        $fro ->Button(-text => "APB HP Zeichnung")      => [2,2],
        $fro ->Button(-text => "HP Werkstattzeichnung") => [3,2],
        
        $fru ->Button(-text => "ende")  =>[0,0],
    );
    
    #my $r = 0;
    #for my $val ('bmf single', 'pdf multi'){
    #    $fro->Radiobutton(-text => $val,
    #                     -value => $val,
    #                     -anchor => 'w',
    #                     -padx => 10, 
    #                     -variable => \$self->{rb_val},
    #                     -command => sub {$self->set_selmode()})
    #                    ->grid(-row => $r, -column => 1, -sticky => "nsew");
    #    $r++;
    #}
   
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
    
    $self->{ftp_liste_b}->configure(-command => sub{$self->do_ftp_liste()});
    
    $self->{template_sizes_b}->configure(-command => sub{$self->do_template_sizes()});
    $self->{apb_hp_zng_b}->configure(-command => sub{$self->do_apb_hp_zng()});
    $self->{ascii_list_b}->configure(-command => sub{$self->do_ascii_lists()});
    $self->{teilzng_b}->configure(-command => sub{$self->do_read_teilzng()});
    $self->{shop_zng_b}->configure(-command => sub{$self->do_shop_zng()});
    
    
  
    $self->{exit_b}  ->configure(-command => sub{$self->do_exit()});
        
}

sub teilzngs_holen{
    my ($self) = @_;
    
    $self->{controler}->message('teilzngs_holen')
}



sub do_ftp_liste{
    my ($self) = @_;
    
    $self->{controler}->message('ftp_liste');
}

#sub set_selmode{
#    my ($self) = @_;
#    
#    $self->{teilzng_lb}->selectionClear(0, 'end');
#    if ($self->{rb_val} eq "bmf single"){
#        $self->{teilzng_lb}->configure(-selectmode => 'single');
#        $self->{zngtype} = "bmf"
#    }
#    #elsif($self->{rb_val} eq "bmf multi"){
#    #    $self->{teilzng_lb}->configure(-selectmode => 'extended');
#    #    $self->{zngtype} = "bmf"
#    #}
#    #elsif($self->{rb_val} eq "pdf single"){
#    #    $self->{teilzng_lb}->configure(-selectmode => 'single');
#    #    $self->{zngtype} = "pdf"
#    #}
#    elsif( $self->{rb_val} eq "pdf multi"){
#        $self->{teilzng_lb}->configure(-selectmode => 'extended');
#        $self->{zngtype} = "pdf";
#    }
#}

sub teilzngs{
    my ($self, $not) = @_;
    
    $self->{teilzngs} = $not->teilzngs();
}

sub do_template_sizes{
    my ($self) = @_;
    
    $self->{controler}->message('template_sizes');
}

sub do_apb_hp_zng{
    my ($self) = @_;
    
    my @lb_inds = $self->{teilzng_lb}->curselection();
    if (defined $lb_inds[0]){
        my @selteilzngs = map {$self->{teilzng_lb}->get($_)} @lb_inds;
        
        for my $tz (@selteilzngs){
            ($tz) = $tz =~ m/\w{3}\#\d{4}-\d{2}-\d{2}\#(\S*)/
        }
        
        $self->{selteilzngs} = \@selteilzngs;
        
        $self->{controler}->message('apb_hp_zng');
    }
    else{
        $self->{prndat} = "Erst mal was wählen\n";
        $self->{trace_t}->printtrace($self);
    }
}

sub do_ascii_lists{
    my ($self) = @_;
    
    $self->{controler}->message("ascii_lists");
}

sub do_shop_zng{
    my ($self) = @_;
    
    my @lb_inds = $self->{teilzng_lb}->curselection();
    if (defined $lb_inds[0]){
        my @selteilzngs = map {$self->{teilzng_lb}->get($_)} @lb_inds;
        $self->{selteilzngs} = \@selteilzngs;
        
        $self->{controler}->message('shop_zng');
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
    
    $self->{controler}->message("read_teilzng");
}

sub do_exit{
    my ($self) = @_;
    $self->{controler}->message('ende');
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