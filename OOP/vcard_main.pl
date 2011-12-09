#!/usr/bin/perl -w
use strict;
use OOP::VCard;

print "Content-type: text/html\n\n";
print '<!DOCTYPE HTML PUBLIC "-//WC3//DTD HTML 4.01 Transitional//EN">', "\n";
print "<html><head><title>Testausgabe</title></head><body>\n";
print "<h1>Tests mit dem VCard-Objekt</h1>\n";

my $Thilo = VCard->new("3.0");
my $Ina = VCard->new("2.0");

print "<p><b>Wert der im Modul erzeugte Objekteigenschaft BEGIN:</b> $Ina->{BEGIN}<br>\n";
my $Sicherung = $Ina->{BEGIN};
$Ina->{BEGIN} = "fangen wir an";
print "<b>BEGIN nach der Wert&auml;nderung:</b> $Ina->{BEGIN}<br>\n";
$Ina->{BEGIN} = $Sicherung;
print "Da dies aber Unsinn ist, wurde der Wert wieder auf '$Ina->{BEGIN}' gesetzt.</p>\n";

$Thilo->VCset("FN","Thilo Teufel");
$Thilo->VCset("TEL_CELL_VOICE","(0170) 398373740");
$Ina->VCset("FN","Ina Bikina");
$Ina->VCset("EMAIL_PREF_INTERNET","bikina\@example.org");

print "<p><b>Name:</b> ",$Thilo->VCget('FN'),"<br>\n";
print "<b>Handy:</b> ",$Thilo->VCget('TEL_CELL_VOICE'),"</p>\n";
print "<p><b>Name:</b> ",$Ina->VCget('FN'),"<br>\n";
print "<b>Handy:</b> ",$Ina->VCget('EMAIL_PREF_INTERNET'),"</p>\n";
#print "<p><b>Anzahl angelegter Objekte:</b> $VCard::Objekte </p>\n";

if(my $Datei = $Thilo->VCsave("/daten/vcard/teufel.vcf")) {
 print "<p>VCard von Thilo Teufel in <tt>$Datei</tt> gespeichert!<br>"
}
else {
 print "VCard von Thilo Teufel konnte nicht gespeichert werden!";
}
$Thilo->VCreset();
print "<p><b>Name von Thilo nach Objekt-Reset:</b> ",$Thilo->VCget('FN'),"<br>\n";
print "<b>Handy von Thilo nach Objekt-Reset:</b> ",$Thilo->VCget('TEL_CELL_VOICE'),"</p>\n";

if($Thilo->VCopen("/daten/vcard/teufel.vcf")) {
 print "VCard von Thilo Teufel wieder ge&ouml;ffnet!<br>";
 print "<p><b>Name von Thilo nach Datei&ouml;ffnen:</b> ",$Thilo->VCget('FN'),"<br>\n";
 print "<b>Handy von Thilo nach Datei&ouml;ffnen:</b> ",$Thilo->VCget('TEL_CELL_VOICE'),"</p>\n";
}
else {
 print "VCard von Thilo Teufel konnte nicht ge&ouml;ffnet werden!";
}

print "</body></html>\n";
