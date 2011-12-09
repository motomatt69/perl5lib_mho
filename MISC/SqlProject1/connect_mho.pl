#!/usr/bin/perl -w
use strict;
use DB::mho;

my $dbh = mho::connect();
print "Verbunden\n";
my$sqlData=$dbh->prepare("SELECT * FROM adressen;");
$sqlData->execute;
while (my$sqlResult = $sqlData->fetchrow_hashref) {
    print $sqlResult->{"vorname"}." ".$sqlResult->{"name"}."\n".$sqlResult->{"strasse"}."\n".$sqlResult->{"plz"}." ".$sqlResult->{"ort"}."\n".$sqlResult->{"telefon"};
    print "___________________\n";
}
$sqlData->finish;

$dbh->disconnect();
print "Verbindung geschlossen\n";

exit (0);


