#!/usr/bin/perl -w
use strict;
# Ins Verzeichnis wechseln
#print "Welches Verzeichnis? [Home-Verzeichnis = leere Zeile) ";
#chomp(my$verz = <STDIN>);
#unless ($verz =~ /^\s*$/) {
my $verz = 'c:\dummy';
    chdir $verz or die "chdir nach '$verz' nicht m�glich: $!";    
#    }

# Verzeichnis �ffnen
opendir Verz1, "." or
    die "Kann das gegenw�rtige verzeichnis nicht �ffnen: $!";
# Dateien im Verzeichnis listen
foreach (sort readdir Verz1) {
    print "$_\n";
}
# Dateien umbennen
 "1.jpg", "3.abc"