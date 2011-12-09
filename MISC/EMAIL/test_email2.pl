#!/usr/bin/perl
use Net::SMTP;
use strict;
my($mailhost,$absender, @empfaenger);

$mailhost='server-email.wendeler.de';
$absender='ich@meine.domain.de';
@empfaenger = ('hofmann@wendeler.de', '090477_baulogis@wendeler.de');

# Objekt erzeugen
my $smtp=Net::SMTP->new($mailhost);

# Absender und Empfeanger
$smtp->mail($absender);
$smtp->to('hofmann@wendeler.de','090477_baulogis@wendeler.de');
#$smtp->cc('090477@wendeler.de');

# Beginne mit dem Senden des Kommandos DATA an den Server
$smtp->data();

# Sende nun die Daten an den Server
$smtp->datasend(<<END);
To: Alle
Subject: Das ist eine Testmail aus dem Tutorial Net::SMTP

Der Text im Body der Mail

dein $absender


END

# Stoppe das senden der Daten an den Server
$smtp->dataend();

# Baue nun die Verbindung ab.
$smtp->quit();
