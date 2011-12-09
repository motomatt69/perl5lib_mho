#!/usr/bin/perl -w
use strict;
# Krümelmonster
my$kekse= " ";

while ($kekse ne "KEKSE") {
    print 'ich will Kekse ';
    chomp ($kekse=<stdin>);
    }

print "Mmmmm. KEKSE.\n";