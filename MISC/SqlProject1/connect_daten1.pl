#!/usr/bin/perl -w
use strict;
use Daten1;

my $dbh = Daten1::connect();
print "Verbunden\n";
$dbh->disconnect();
print "Verbindung geschlossen\n";

exit (0);


