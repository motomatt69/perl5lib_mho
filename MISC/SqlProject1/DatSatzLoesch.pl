#!/usr/bin/perl -w
use strict;
use DB::mho;


my $dbh = DBI->connect('DBI:mysql:database=profile;host=localhost','root','');
print "Verbunden\n";

my $tabelle="prof_main";
my $sth1=$dbh->prepare(qq/DELETE FROM $tabelle/);



$dbh->disconnect();
print "Verbindung geschlossen\n";