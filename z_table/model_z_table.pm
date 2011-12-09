package z_table::model_z_table;
use strict;
use z_table::db_abfragen;

sub new {
    my ($class)=@_;
    my $obj = bless ({}, $class);
    return $obj
}
#SetGet Controller    
sub set_controler {
    my ($obj, $controler_obj) = @_;
    $obj->{controler} = $controler_obj;
}
sub get_controler {
    my ($obj) = @_;
    return $obj->{controler};
}
#Auftragsnummer#################################################################
#Letzte Auftragsnummer einlesen
sub Anr_lesen {
    my ($obj) = @_;
    my $anr = $obj->_auf_read();
    $obj->set_anr($anr);
    
    my $cont = $obj->get_controler();
    $cont->sende('m_AuftragAkt');
}
# Auftragsnummer abspeichern
sub Anr_schreiben {
    my ($obj) = @_;
    my $anr=$obj->get_anr();
    $obj->_auf_write($anr); 
    print "abgespeichert: $anr\n";
}
#SetGet für Auftragsnummer
sub set_anr {
    my ($obj,$anr) = @_;
    $obj->{anr}=$anr;
    print "Model: ", $anr, "\n";
}
sub get_anr {
    my ($obj)=@_;
    return $obj->{anr}
}
#Auftragsliste##################################################################
#Auftragsliste einlesen    
sub anrlist {
    my ($obj) = @_;
    
    #my @AnrList=("090717  Baumhaus", "090333  Holzbrücke");
    #my $AnrListRef=\@AnrList;
    my $AnrListRef = z_table::db_abfragen::auftragsliste();
    $obj->set_anrlist($AnrListRef);
    my $cont = $obj->get_controler();
    $cont->sende('m_AnrList');
}

#SetGet für Auftragsliste    
sub set_anrlist {
    my ($obj,$anrlist) = @_;
    $obj->{anrlist}=$anrlist;
}
sub get_anrlist {
    my ($obj)=@_;
    return $obj->{anrlist}
}    

#Auftragsdaten##################################################################
#Auftragsdaten lesen    
sub AnrDat_lesen {
    my ($obj) = @_;
    my $anr=$obj->get_anr;
    #my $AnrDatRef = 25;
    my $AnrDatRef = z_table::db_abfragen::auftragsdaten($anr);
    #$AnrDatRef = 25;
    $obj->set_anrdat($AnrDatRef);
    my $cont = $obj->get_controler();
    $cont->sende('m_AnrDat');
}

#SetGet für Auftragsdaten
sub set_anrdat {
    my ($obj,$AnrDatRef) = @_;
    $obj->{anrdat}=$AnrDatRef;
}
sub get_anrdat {
    my ($obj)=@_;
    return $obj->{anrdat}
}    

#Zeichnungsdaten##################################################################
#Zeichnungsdaten lesen
sub ZngDat_lesen {
    my ($obj) = @_;
    my $anr=$obj->get_anr;
    my $tx_zdat=$obj->get_zngdat;
    
    %$tx_zdat = map { ("0,$_" => $tx_zdat->{"0,$_"}) } (0..11);
    
    $tx_zdat=z_table::db_abfragen::zeichnungsdaten($anr,$tx_zdat);
    #$tx_zdat->{rows}=(5); 
   # $tx_zdat->{'1,0'}="11111";
    #$tx_zdat->{'1,1'}="01";
    #if ($anr == '090171') {$tx_zdat->{'1,4'}="090171 Zeichnung"}
    
    $obj->set_zngdat($tx_zdat);
    my $cont = $obj->get_controler();
    $cont->sende('m_ZngDat');
}


#SetGet für Zeichnungsdaten
sub set_zngdat {
    my ($obj,$tx_zdat) = @_;
    $obj->{zngdat}=$tx_zdat;
    1;
}
sub get_zngdat {
    my ($obj)=@_;
    return $obj->{zngdat}
}    











###############################################################################
###############################################################################
#Abgespeicherte Auftragnummer
sub _auf_read {
    if (-e 'aufakt') {
        open (INFILE, 'aufakt');
        my @zeile = <INFILE>;
        close INFILE;
        return $zeile[0];
    }
}

sub _auf_write {
    my ($obj,$anr)=@_;
    open (OUTFILE, ">aufakt"); #Aktueller Auftrag in Datei schreiben
    print OUTFILE $anr;
    close OUTFILE;
}


1;