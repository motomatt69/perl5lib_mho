#!/usr/bin/perl -w
use strict;
use mho;

#Alle Datens�tze einer Tabelle l�schen
my $dbh = mho::connect();

my  $sqlData=$dbh->prepare("DELETE FROM bte ");
    $sqlData->execute;

$sqlData->finish;
$dbh->disconnect();