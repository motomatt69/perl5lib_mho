package Moose::lightsource;
use strict;

use Moose;

has 'candle_power', is => 'ro', isa => 'Int',   default => 1;
has 'enabled',      is => 'ro', isa => 'Bool',  default => 0,
                    writer => '_set_enabled';
                    
sub light{
    my ($self) = @_;
    
    $self->_set_enabled(1);
}

sub extinguish{
    my ($self) = @_;
    
    $self->_set_enabled(0);
}

1;

