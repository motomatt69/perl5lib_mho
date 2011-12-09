#!/usr/bin/perl -w
use strict;
my ( @nums, %freq);
my $count = 0;
my $maxfreq = 0;
my $sum = 0;
while (defined (my$input = <>)) {
    chomp $input;
    $nums[$count] = $input;
    $freq{$input}++;
    if ($maxfreq < $freq{$input}) {$maxfreq = $freq{$input}};
    $count++;
    $sum += $input;
    }
@nums = sort {$a <=> $b} @nums;

my $avg = $sum / $count;
my $med = $nums[$count/2];

print "Die Anzahl der eingebenen Werte : $count\n";
print "Summe der Werte: $sum\n";
print "Kleinste Zahl: $nums[0]\n";
print "Groesste Zahl: $nums[$#nums]\n";
printf ("Durchschnitt: %.2f\n", $avg);
print "Mittelwert: $med\n\n";

my @keys = sort {$a <=> $b} keys %freq;

my ($i,$zahl,$space,$totalspace);

for ($i = $maxfreq ; $i>0 ; $i--) {
    foreach $zahl (@keys) {
        $space = (length $zahl);
        if ($freq{$zahl} >= $i) {
            print (  (" " x $space) . "x");
        } else {
            print " " x (($space) + 1);
        }
        if ($i == $maxfreq) {$totalspace += $space + 1}
    }
    print "\n";
}
print "-" x $totalspace;
print "\n @keys\n";
