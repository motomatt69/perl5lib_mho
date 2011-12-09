package Moose::calculate_age_from_birthyear;
use strict;

use Moose::Role;

has 'birth_year',   is => 'ro', isa => 'Int',
                    default => (localtime)[5] + 1900;

sub age{
    my ($self) = @_;
    
    my $year = (localtime)[5] + 1900;
    
    return $year - $self->birth_year();
}

1;