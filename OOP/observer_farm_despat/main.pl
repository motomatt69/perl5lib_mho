#!/usr/bin/perl -w
package main;
use strict;
use OOP::observer_farm_despat::subject;
use OOP::observer_farm_despat::Pferde;
use OOP::observer_farm_despat::Kuehe;


#subject ist der Bauer
my $Bauer = subject->new();

#Beobachter sind die Tiere
my $Pferd = Pferde->new();
my $Kuh = Kuehe->new();

#Tiere dem Bauer bekanntmachen
$Bauer->addObserver($Pferd);
$Bauer->addObserver($Kuh);


$Bauer->Es_gibt_Gras();
$Bauer->Es_gibt_Mais();
$Bauer->Es_gibt_Gras();
my $dummy;
1;