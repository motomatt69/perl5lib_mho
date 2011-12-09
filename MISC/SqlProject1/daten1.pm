#!/usr/bin/perl -w
package Daten1;
use strict;
use DBI;

sub connect {

my $db_name = "daten1";
my $host_name= "localhost";
my $user_name = "root";
my $passwort = "mho01";
my $dsn = "DBI:mysql:host=$host_name;database=$db_name";

return (DBI->connect($dsn, $user_name, $passwort,
                     {PrintError => 0, RaiseError => 1}));
}

1;#Gib wahr zurück