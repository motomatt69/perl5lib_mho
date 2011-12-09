#!/usr/bin/perl -w
use strict;
package Pferde;
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;

Pferde->mk_accessors qw(Farbe Beine Besitzer Name);



package main;

my $Ed = Pferde->new ({Farbe => 'braun', Beine => 3});
my $Stallion = Pferde->new ({Farbe => 'schwarz', Beine => 26});
my $Gaul = Pferde->new;

print $Ed->get_Farbe,"\n";
$Stallion->set_Besitzer('Heinz Dieter');
print $Stallion->get_Farbe,"\n";
print $Stallion->get_Besitzer,"\n";
$Ed->set_Farbe('gruen');
print $Ed->get_Farbe,"\n";
print $Ed->get_Besitzer,"\n";

$Gaul -> set_Farbe('gelb');
$Gaul -> set_Beine('853');
$Gaul -> set_Name('KeinzBembel');

print $Gaul -> get_Name



