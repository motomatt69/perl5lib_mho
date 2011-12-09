#!/usr/bin/perl -w
use strict;
my$zahl1=undef; my$zahl2=undef; my$count=undef; my@zahlen=();
print "Bitte eine Zahl eingeben: ";
chomp($zahl1=<STDIN>);
print "Bitte eine Zahl eingeben: ";
chomp($zahl2=<STDIN>);
    if ($zahl1<=$zahl2) {
    @zahlen=($zahl1..$zahl2);    
    }else {
        @zahlen=($zahl2..$zahl1); 
    }
    
   
print"@zahlen\n" ;

