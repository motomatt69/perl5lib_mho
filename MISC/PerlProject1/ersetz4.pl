#!/usr/bin/perl -w
use strict;

my $eingabe = "C:\\Programme\\perl\\projekte\\PerlProject1\\Text1.ein";
unless (defined $eingabe) {
    die "Benutzung: $0 Dateiname";
}
my $ausgabe = $eingabe;
$ausgabe =~ s/(\.\w*)?$/.out/;

unless (open EIN, "<$eingabe") {
    die "kann '$eingabe' nicht öffnen: $!";
}

unless( open AUS, ">$ausgabe") {
    die "Kann nicht in '$ausgabe' schreiben: $!";
}

while(<EIN>) {
    chomp;
    s/Larry/Matthias/gi;
    print AUS "$_\n";
    foreach(1..1000) {
        print AUS "$_|\n";
    }
}
    