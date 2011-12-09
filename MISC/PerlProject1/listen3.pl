#!/usr/bin/perl -w
use strict;

my ($satz,$zeichen);
print "Satz eingeben\n";
chomp ($satz=<STDIN>);
print "zeichen eingeben\n";
chomp ($zeichen=<STDIN>);
my $pos=0; my $count=0;   
    while ($pos < length($satz)and $pos != -1){
        $pos = index($satz,$zeichen,$pos);
        if ($pos !=-1) {
            $pos++;
            $count++;
            print $pos,"\n";
            print $count,"-----\n";
        }
    }
