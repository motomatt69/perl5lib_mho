#!/usr/bin/perl -w
use strict;

my $num;
my $exit="";
while ($exit ne "n") {
    
    while () {
    print "Geben Sie die zu buchstabierende Zahl ein: ";
    chomp ($num = <STDIN>);
    if ($num ne "0" && $num == 0) {
        print "Keine Strings, eine Zahl von 0 bis 9 bitte.\n";
        next;
    }
    if ($num >9) {
        print "Nur einstellige Zahlen.\n";
        next;
    }
    if ($num <0) {
        print "Keine negativen Zahlen.\n";
        next;
    }
    last;    
}

print "$num ist ";
if ($num == 1) {print 'eins'}
if ($num == 2) {print 'zwei'}
if ($num == 3) {print 'drei'}
if ($num == 4) {print 'vier'}
if ($num == 5) {print 'fuenf'}
if ($num == 6) {print 'sechs'}
if ($num == 7) {print 'sieben'}
if ($num == 8) {print 'acht'}
if ($num == 9) {print 'neun'}
print "\n";

    while () {
        print "Eine weitere Zahl versuchen (j/n): ";
        chomp ($exit=<STDIN>);
        $exit = lc ($exit);
        if ($exit ne 'j' and $exit ne 'n') {
            print "j oder n bitte.\n";
        } else {
            last;
        }    
    }    
}
