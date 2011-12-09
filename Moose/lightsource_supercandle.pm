package Moose::lightsource_supercandle;
use strict;

use Moose;

extends 'Moose::lightsource';

has '+candle_power', default => 100;

1;