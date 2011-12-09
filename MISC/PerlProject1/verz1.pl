#!/usr/bin/perl -w
use strict;
# Ins Verzeichnis wechseln
print "Welches Verzeichnis? [Home-Verzeichnis = leere Zeile) ";
chomp(my$verz = <STDIN>);
unless ($verz =~ /^\s*$/) {
    chdir $verz or die "chdir nach '$verz' nicht möglich: $!";    
    }

# Dateien im Verzeichnis listen

my @dateien = <*>;
foreach (@dateien) {
    print "$_\n";
}