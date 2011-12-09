#!/usr/bin/perl -w
use strict;
# Ins Verzeichnis wechseln
#print "Welches Verzeichnis? [Home-Verzeichnis = leere Zeile) ";
#chomp(my$verz = <STDIN>);
#unless ($verz =~ /^\s*$/) {
my $verz = 'c:\dummy';
    chdir $verz or die "chdir nach '$verz' nicht möglich: $!";    
#    }

# Verzeichnis öffnen
opendir Verz1, "." or
    die "Kann das gegenwärtige verzeichnis nicht öffnen: $!";
# Dateien im Verzeichnis listen
foreach (sort readdir Verz1) {
    print "$_\n";
}
# Dateien umbennen
 "1.jpg", "3.abc"