package MISC::MVC::SIMPLE::controler;
use strict;
use warnings;

use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub lesen{
    my ($self, $daten) = @_;
    
    $self->readfile($daten);
}

no Moose;



1;
