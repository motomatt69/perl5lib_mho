#!/usr/bin/perl -w
use strict;
use DB::mho;

my $dbh = mho::connect();
print "Verbunden\n";


#Alle Datensätze in Tabelle adressen abfragen:
my$sqlData=$dbh->prepare("SELECT * FROM adressen;");
$sqlData->execute;
while (my$sqlResult = $sqlData->fetchrow_hashref) {
    print $sqlResult->{"vorname"}." ".$sqlResult->{"name"}."\n".$sqlResult->{"strasse"}."\n".$sqlResult->{"plz"}." ".$sqlResult->{"ort"}."\n".$sqlResult->{"telefon"};
    print "___________________\n";
}
$sqlData->finish;
# Nur den Datensatz mit name Muster abfragen
$sqlData=$dbh->prepare("SELECT * FROM adressen
                       Where name = 'Muster';");
$sqlData->execute;
while (my$sqlResult = $sqlData->fetchrow_hashref) {
    print $sqlResult->{"vorname"}." ".$sqlResult->{"name"}."\n".$sqlResult->{"strasse"}."\n".$sqlResult->{"plz"}." ".$sqlResult->{"ort"}."\n".$sqlResult->{"telefon"};
    print "___________________\n";
}
$sqlData->finish;
# Einen Datensatz einfügen
my %adr = ('vorname'=>'Egon', 'name'=>'Müller', 'strasse'=>'Nebenstrasse3', 'plz'=>'7777', 'ort'=>'Donzdorf', 'telefon'=>'0121231');
#$sqlData=$dbh->prepare("INSERT INTO adressen (vorname, name, strasse, plz, ort, telefon) VALUES
#                       ('".$adr{vorname}."','".$adr{name}."','".$adr{strasse}."','".$adr{plz}."','".$adr{ort}."','".$adr{telefon}."');");
#                        ##('Egon','Meier','Nebenstrasse','7777','Dorf','99999');");
$sqlData=$dbh->prepare(qq/INSERT INTO adressen ( name, strasse, plz, ort, telefon) VALUES
                       ('$adr{name}','$adr{strasse}','$adr{plz}','$adr{ort}','$adr{telefon}');/);
                        



my $rowsAffected=$sqlData->execute;
#Überprüfung ob es geklappt hat
if ($rowsAffected>0) { #wenn 1 oder mehrere Datensätze betroffen ist alles ok
    print "Abfrage erfolgreich: $rowsAffected Datensätze betroffen. ID des Datensatzes: ".$dbh->{'mysql_insertid'}.".\n";
}else {
    print "Es ist ein Fehler aufgetreten: ".$dbh->errstr."\n";
}
$sqlData->finish;


#Datenbankverbindung trennen
$dbh->disconnect();
print "Verbindung geschlossen\n";

exit (0);


