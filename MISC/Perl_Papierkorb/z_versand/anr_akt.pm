#!/usr/bin/perl -w
package z_versand::anr_akt;

use DB::Archiv;
use strict;

sub new {
    my $class = shift;
    my $obj = bless ({},$class);
#abgespeicherte Auftragsnummer holen und von ListboxNr trennen holen    
    my $anr_akt = auf_read();
    my $lboxNr;
    if ($anr_akt=~ m/(\d+);(\d)/) { #Auftragsnummer von ListboxIndex trennen
        $anr_akt=$1; 
        $lboxNr=$2;
    }
#Auftragsdaten holen    
    my $anr_dat = DB::Archiv->get_auftrag($anr_akt);
    $obj->{'_anr_dat_db'}=$anr_dat;

    return $obj;
}


#Auftragdaten ausgeben
sub get_auftragsnummer {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->auf_data_anr()
}
sub get_auftraggeber {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->auf_data_ag()
}
sub get_architekt {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->auf_data_arch()
}
sub get_bezeichnung {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->auf_data_bez()
}
sub get_projektleiter {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->auf_data_projekt_leiter()
}
#Zeichnungsanzahl ausgeben
sub get_anzahl_blaetter {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->anzahl_zeichnungen('all')
}
sub get_anzahl_blaetter_mit_index {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->anzahl_zeichnungen('index')
}
sub get_anzahl_blaetter_ohne_index {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->anzahl_zeichnungen('no_index')
}
sub get_anzahl_teilsysteme {
    my $obj = shift;
    return $obj->{'_anr_dat_db'}->anzahl_zeichnungen('ts')
}

###################################################################################################################
#Abgespeicherte Auftragnummer
sub auf_read {
    if (-e 'aufakt') {
        open (INFILE, 'aufakt');
        my @zeile = <INFILE>;
        close INFILE;
        my$aufakt=$zeile[0];
    }
}

sub auf_write {
    my ($aufakt)=@_;
    open (OUTFILE, ">aufakt"); #Aktueller Auftrag in Datei schreiben
    print OUTFILE $aufakt;
    close OUTFILE;
}


1;

