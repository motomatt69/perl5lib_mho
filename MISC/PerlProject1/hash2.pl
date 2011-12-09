#!/usr/bin/perl -w
use strict;
my%personen = (
    "Fred" => "Feuerstein",
    "Barney" => "Geroellheimer",
    "Wilma" => "Feuerstein",
    );
    
print "Bitte einen Vornamen eingeben: ";
chomp(my$vorname=<STDIN>);
print"________________.\n";
print $vorname . "\n";
print "Der vollstaendige Name lautet: $vorname $personen{$vorname}.\n";


