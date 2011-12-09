package PPEEMS::SHOPDWG::view;
use strict;

use Tk;
use Tk::Utils::MainApp::MVC::View::Trace;
use Tk::Utils::Grid;

use Moose;
BEGIN {extends 'Patterns::MVC::View'};

has 'mw'        => (isa => 'Object',  is => 'rw', required => 0);
has 'prndat'    => (isa => 'Str',     is => 'rw', required => 0);
has 'pfad'      => (isa => 'Str',     is => 'rw', required => 0);

sub init{
    my ($self) = @_;
#frames           
    my $mw = $self->widget($self->mvcname());
    my (undef, $fr) = configGrid(
        $mw => {-row => ['640v'],
                -col => ['800v']},
        $mw->Frame()=>{-row => ['32', '300v', '32'],
                       -col => ['800v'],
                       -grid => [0,0]},
    );
    
    my ($fro, $frm, $fru) = configGrid(
        $fr->Frame()=>{-row => [qw/32/],
                       -col => [qw/600v/],
                       -grid => [0,0]},
        $fr->Frame()=>{-row => ['300v'],
                       -col => ['600v'],
                       -grid => [1,0]},
        $fr->Frame()=>{-row => ['32'],
                       -col => ['600v'],
                       -grid => [2,0]},
    );

#Buttons für Aktion
    (   $self->{path_lb},
        
        $self->{exit_b}
    ) = multiGrid(
        $fro->Label(-text => 'Label')=> [0,0],
        
        $fru->Button(-text => "ende")  =>[0,0],
    );
    
    $self->{trace_t} = Tk::Utils::MainApp::MVC::View::Trace->new($frm);
    $self->{trace_t}    ->grid(0, 0);
    
    $self->{exit_b}  ->configure(-command => sub{exit});    
}

sub zeichnungen_fehlen{
    my ($self, $not) = @_;
        
    #$self->teilzngs_holen();
    #$self->{teilzng_lb}->delete(0,'end');
    #$self->{teilzng_lb}->insert('end',@{$self->{teilzngs}});
}

sub printtrace{
    my ($self, $not) = @_;
    
    $self->{prndat} = $not->{prndat};
    $self->{trace_t}->printtrace($self);
}

1;