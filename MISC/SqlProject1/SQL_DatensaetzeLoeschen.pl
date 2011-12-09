#!/usr/bin/perl -w
use strict;
use mho;

#Alle Datensätze einer Tabelle löschen
my $dbh = mho::connect();

my  $sqlData=$dbh->prepare("DELETE FROM bte ");
    $sqlData->execute;

$sqlData->finish;
$dbh->disconnect();