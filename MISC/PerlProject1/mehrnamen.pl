#!/usr/bin/perl -w
use strict;


my (@raw,%names,$fn,$i);
while (<>) {
    chomp;
    @raw =split (" ",$_);
    if ($#raw == 1) {
        $names{ $raw[1]} = $raw[0];
    }else{
        $fn = "";
        for ($i = 0; $i < $#raw;$i++) {
            $fn .= $raw[ $i] . " ";
        }
        $names{$raw[$#raw]} = $fn;
    }
}

my $exit=1;
while($exit) {
    print "\n1. Namensliste nach Nachnamen sortieren\n";
    print "2. Namensliste nach Vornamen sortieren\n";
    print "3. Namen suchen\n";
    print "4. Beenden\n\n";
    print "Geben Sie eine Zahl ein: ";
    
    chomp(my$in = <STDIN>);
    my $name;
    
    if ($in eq '1') {  #Liste nach Nachnamen sortiert
    foreach $name (sort keys %names) {
        print "$name, $names{ $name}\n"
        }
    }elsif ($in eq '2') {  #Liste nach Vornamen sortieren
        my@keys = sort { $names{ $a} cmp $names{$b}} keys %names;
        foreach $name (@keys) {
            print "$names{ $name} $name\n";
        }
    }elsif ($in eq '3') { # Namen finden (1 oder mehr)
        print "Wonach suchen?";
        chomp(my$search=<STDIN>);
        
        my@keys=();
        my@n=();
        while (@n = each %names) {
            if (grep /$search/, @n) {
                $keys[ ++$#keys] = $n[ 0];
            }
        }
        if (@keys) {
            print "gefundene Namen: \n";
            foreach $name (sort @keys) {
                print "   $names{ $name} $name\n";
            }
        }else{
            print "Nichts gefunden.\n";
        }
        
    }elsif ($in eq '4') {
        $exit = 0
    }else{
        print "Eingabefehler. 1 bis 4 bitte.\n";
    }
}
    