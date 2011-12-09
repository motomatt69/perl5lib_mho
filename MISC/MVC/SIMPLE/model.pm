package MISC::MVC::SIMPLE::model;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Model'};

sub readfile{
    my ($self, $daten) = @_;
    
    $self->{gelesenedaten} = 'GeleseneDaten';
    
    $self->notify('Daten_gelesen');
    my $dummy;
}


no Moose;


1;
