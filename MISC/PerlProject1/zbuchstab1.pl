#!/usr/bin/perl -w
use strict;

my $exit="";
while ($exit ne "n") {
    
    while () {
    print "Geben Sie die zu buchstabierende Zahl ein: ";
    chomp ($_ = <STDIN>);
    if (/^\d$/) { #nur Zahlen
        print "Danke!\n";
        last;
    }elsif (/^$/) {
        print "Sie haben nichts eingeben.\n";
    }elsif (/\D/){
        if (/[ a-zA-Z]/){
            print "Die Eingabe enthält Buchstaben.\n";
        }elsif (/^-\d/){
            print "Keine negativen Zahlen bitte.\n";
        }elsif (/\./){
            print "Keine Dezimalzahl bitte.\n";
        }elsif(/[ \W_]/){
            print "Was ist das?.\n";
        }
    }elsif ($_ >9){
        print "Zu gross!\n";
    }
}
print "$_ ist ";
/1/ && print 'eins';
/2/ && print 'zwei';
/3/ && print 'drei';
/4/ && print 'vier';
/5/ && print 'fuenf';
/6/ && print 'sechs';
/7/ && print 'sieben';
/8/ && print 'acht';
/9/ && print 'neun';
print "\n";

    while () {
        print "Eine weitere Zahl versuchen (j/n): ";
        chomp ($exit=<STDIN>);
        $exit = lc ($exit);
        if ($exit =~ /^[j|n]/) {
            last;            
        } else {
            print "j oder n bitte.\n";
        }    
    }    
}
