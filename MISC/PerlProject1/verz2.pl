#!/usr/bin/perl -w
use strict;
# Ins Verzeichnis wechseln
print "Welches Verzeichnis? [Home-Verzeichnis = leere Zeile) ";
chomp(my$verz = <STDIN>);
unless ($verz =~ /^\s*$/) {
    chdir $verz or die "chdir nach '$verz' nicht möglich: $!";    
    }

# Verzeichnis öffnen
opendir Verz1, "." or
    die "Kann das gegenwärtige verzeichnis nicht öffnen: $!";
# Dateien im Verzeichnis listen
foreach (sort readdir Verz1) {
    print "$_\n";
}
print "zu loeschende Dateien eingeben: \n";
foreach (@ARGV) {
    unlink $_ or warn "Kann $_ nicht löschen: $!, Programm geht weiter.\n";
}