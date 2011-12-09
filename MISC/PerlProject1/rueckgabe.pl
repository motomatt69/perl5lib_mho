#!/usr/bin/perl -w
use strict;
my $Befehlszeile = "c:\\programme\\perl\\bin\\perl.exe C:\\PERL_projekte\\PerlProject1\\Exittest.pl";
my $e = system $Befehlszeile;
my $ausgabe = `$Befehlszeile`;
print "$e\n";
print "1:$ausgabe\n";

