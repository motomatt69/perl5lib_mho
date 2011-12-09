#!/usr/bin/perl -w
use strict;

use OOP::TKonto;
  
my $boss_konto = new TKonto (1000000, 70000);
my $mein_konto = new TKonto (200, 500);
my $Kollege_konto = new TKonto (50000, 5000);
# Vor und nach der Überweisung muss die Summe gleich sein.
 
print "\nVor der Ueberweisung\n";
printf "Boss Konto: %9d\n", $boss_konto->getKontostand();
printf "Mein Konto: %9d\n", $mein_konto->getKontostand();
printf "Koll Konto: %9d\n", $Kollege_konto->getKontostand();
printf "Summe     : %9d\n", $boss_konto->getKontostand()+$mein_konto->getKontostand()+$Kollege_konto->getKontostand();

$boss_konto->addiere(10000);
printf "Boss Konto: %9d\n", $boss_konto->getKontostand();

$boss_konto->ueberweise ($mein_konto, 1000);
$boss_konto->ueberweise($Kollege_konto, 3000);
   
print "\nNach der Ueberweisung\n";
printf "Boss Konto: %9d\n",$boss_konto->getKontostand();
printf "Mein Konto: %9d\n",$mein_konto->getKontostand();
printf "Koll Konto: %9d\n",$Kollege_konto->getKontostand();
printf "Summe     : %9d\n",$boss_konto->getKontostand()+$mein_konto->getKontostand()+$Kollege_konto->getKontostand();
  
__END__
  
