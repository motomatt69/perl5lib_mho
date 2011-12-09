package Moose::cheese;
use strict;
use Moose::calculate_age_from_birthyear;

use Moose;

has 'name',         is => 'ro', isa => 'Str';
has 'besitzer',     is => 'ro', isa => 'Str';
#has 'birth_year',   is => 'ro', isa => 'Int',
#                    default => (localtime)[5] + 1900;
                    
with 'Moose::calculate_age_from_birthyear';

no Moose;


1;