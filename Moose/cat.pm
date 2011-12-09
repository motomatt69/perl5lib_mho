package Moose::cat;
use strict;
use Moose::living_being;
use Moose::calculate_age_from_birthyear;

use Moose;

has 'name',         is => 'ro', isa => 'Str';
has 'besitzer',     is => 'ro', isa => 'Str';
has 'diet',         is => 'rw', isa => 'Str';
#has 'birth_year',   is => 'ro', isa => 'Int';

with 'Moose::living_being', 'Moose::calculate_age_from_birthyear';





no Moose;


1;