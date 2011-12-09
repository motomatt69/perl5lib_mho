#!/usr/bin/perl -w
use strict;
use z_versand::anr_akt;

my ($anr_akt) = z_versand::anr_akt->new();

print $anr_akt->get_auftragsnummer(),"\n";
print $anr_akt->get_auftraggeber(),"\n";
print $anr_akt->get_architekt(),"\n";
print $anr_akt->get_bezeichnung(),"\n";
print $anr_akt->get_projektleiter(),"\n\n";

print "Blätter  ",$anr_akt->get_anzahl_blaetter(),"\n";
print "Blätter mit Index ",$anr_akt->get_anzahl_blaetter_mit_index(),"\n";
print "Blätter ohne Index ",$anr_akt->get_anzahl_blaetter_ohne_index(),"\n";
print "Teilsysteme ",$anr_akt->get_anzahl_teilsysteme(),"\n\n\n";

