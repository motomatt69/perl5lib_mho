#!/usr/bin/perl -w
package main;
use strict;
use OOP::observer_farm::subject;
use OOP::observer_farm::Pferde;
use OOP::observer_farm::Kuehe;


#subject ist der Bauer
my $Bauer = subject->new();

#Beobachter sind die Tiere
my $Pferd = Pferde->new();
my $Kuh = Kuehe->new();

#Tiere dem Bauer bekanntmachen
$Bauer->addobserver($Pferd);
$Bauer->addobserver($Kuh);

#Der Bauer hat Gras als Futter


my $dummy;
1;