#!/usr/bin/perl -w
use strict;
use Moose::lightsource;
use Moose::lightsource_supercandle;

my $light1 = Moose::lightsource->new();

my $an = $light1->light();
print $light1->candle_power(), "\n";


my $light2 = Moose::lightsource_supercandle->new();
print $light2->candle_power(), "\n";

my $dummy;