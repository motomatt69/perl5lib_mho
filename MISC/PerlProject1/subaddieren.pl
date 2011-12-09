#!/usr/bin/perl -w
use strict;

print 'geben Sie eine Zahle ein :';
    chomp(my $zahl1 =<STDIN>);
    print 'Geben Sie noch eine Zahle ein:';
    chomp (my $zahl2 = <STDIN>);

my $sum = &sumnums($zahl1,$zahl2);
print "Summe: $sum\n";

sub sumnums {
    my($wert1,$wert2)=@_;
    foreach $_ (@_){
        $sum += $_
    }
    return $sum
}