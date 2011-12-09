#!/usr/bin/perl -w
# use strict;
$input = ''; # benutzereingaben
@nums = (); # zahlenarray
%freg = (); #hash Zahl Häufigkeit
$count = 0; # Zähler
$sum = 0; # Summe
$avg = 0; #Durchschnitt
$med = 0; #Median
$maxspace = 0; #maximaler platz für die schlüssel

while () {
    print 'Bitte eine Zahl eingeben: ';
    chomp ($input = <STDIN>);
    if ($input ne '') {
        $nums[$count] = $input;
        $freg{$input}++;
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
print "Median: $med\n\n";
print "Häufigkeit der einzelnen Zahlen:\n";

$maxspace = length ($nums[$#nums]) + 1;
foreach $key (sort {$a <=>$b } keys %freg) {
    print $key;
    print ' ' x ($maxspace - length $key);
    print '| ', '*' x $freg{$key}, "\n";
}