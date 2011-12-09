package MISC::MVC::SIMPLE::view;
use strict;
use warnings;
use Tk::Utils::Grid;

use Moose;
BEGIN {extends 'Patterns::MVC::View'};

sub init {
    my ($self) = @_;
    
    my $mw = $self->widget();
    
    my (undef, $fo, $fu) = configGrid(
        $mw => {-row => ['64v', '32v'],
                -col => ['256v']},
        $mw->Frame() => {-row => ['64v'],
                         -col => ['128v'],
                         -grid => [0, 0]},
        $mw->Frame() => {-row => ['64v'],
                         -col => ['128v'],
                         -grid => [1, 0]},
    );
    
    (
        $self->{lesen_b},
        
        $self->{exit_b}
    ) = multiGrid(
        $fo -> Button(-text => "lesen") => [0, 0],
        
        $fu -> Button(-text => "exit") => [0, 0]
    );
    
    $self->{lesen_b}->configure(-command => sub{$self->lesen('Daten')});
    $self->{exit_b}->configure(-command => sub{exit});
}

sub Daten_gelesen{
    my ($self, $not) = @_;
    
    my $gelesenedaten = $not->{gelesenedaten};
    print "view : $gelesenedaten";

}
1;
