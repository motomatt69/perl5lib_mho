#!/usr/bin/perl -w
#Verbinden mit mho-datenbank
package Lieferschein::mho;
use strict;
use DBI;

sub connect {

my $db_name = "mho";
my $host_name= "server-sql";
my $user_name = "mho";
my $passwort = "geheim";
my $dsn = "DBI:mysql:host=$host_name;database=$db_name";

return (DBI->connect($dsn, $user_name, $passwort,
                     {PrintError => 0, RaiseError => 1}) or die ("Verbindung fehlgeschlagen: ".DBI->errstr));
}

1;#Gib wahr zurück

#('DBI:mysql:host=server-sql;database=mho,mho,geheim')