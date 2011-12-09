#!/usr/bin/perl -w
# use strict;
$input = ''; # benutzereingaben
@nums = (); # zahlenarray
$count = 0; # Zähler
$sum = 0; # Summe
$avg = 0; #Durchschnitt
$med = 0; #Median

while () {
    print 'Bitte eine Zahl eingeben: ';
    chomp ($input = <STDIN>);
    if ($input ne '') {
        $nums[$count] = $input;
        $count++;
        $sum += $input;
    }
    else { last; }
}

@nums = sort {$a <=> $b} @nums;
$avg = $sum / $count;
$med = $nums[$count/2];

print "\nAnzahl der eingegebenen Zahlen : $count\n";
print "Summe der eingebenen Zahlen: $sum\n";
print "Hoechste Zahl: $nums[$#nums]\n";
print "Niedrigeste Zahl: $nums[0]\n";
printf("Durchschnitt: %.2f\n", $avg);
print "Median: $med\n";
print "@nums";

print "Eingeben: ";
print "@nums\n";
#print scalar (@nums);

$, = 'xx';
print "Liste: ";
print (1,2,3,4,5,6,9);