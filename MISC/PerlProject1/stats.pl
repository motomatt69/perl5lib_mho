#!/usr/bin/perl -w
use strict;
my$input=undef;my$sum=undef;my$count=undef;my$avg=undef;

 
while(){
        print "Bitte eine Zahl eingeben: ";
        chomp($input=<STDIN>);
        if ($input ne'')  {
            $count++;
            $sum += $input;
        }
        else {last; }
  }
 
$avg = $sum / $count;
print "Anzahle der eingebenen Zahlen: $count \n";
print "Gesamtsumme: $sum \n";
print "Durchschnitt: $avg\n";
printf ("Durchschnitt gerundet: %d\n",  $avg);
