package z_table::db_abfragen;
use strict;
use DB::Archiv qw(get_auftrag);

require Exporter;
our @ISA = qw(Exporter);
#our @EXPORT = qw(aufabfrag aufdat zngabfrag zngzaehl );
our @EXPORT_OK= qw ($AnrListRef $AnrDatRef);

my $dbh = DB::Archiv->get_db_handle();
#Auftragsliste für Listbox aus Datenbank holen
sub auftragsliste {


my $sql = <<'SQL';
                    SELECT concat(auf_data_anr, '  ', auf_data_bez)
                    FROM   auf_data
                    ORDER BY auf_data_anr DESC
SQL
    
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    my $auf_ref = $sth->fetchall_arrayref();
    $sth->finish();

    my @AnrList = map { $_->[0] } @$auf_ref;
    
    return my $AnrListRef=\@AnrList;
}

#Auftragsdaten für Anzeigefenster aus Datenbank holen
sub auftragsdaten {
    my ($anr) = @_;
    
    my $anrdat = DB::Archiv->get_auftrag($anr);
    print "db_abfrag: ",$anrdat->auf_data_anr(),"\n";
    print "db_abfrag: ",$anrdat->auf_data_ag(),"\n";
    
    my $AnrDatRef->{'anr'}=$anrdat->auf_data_anr();
       $AnrDatRef->{'ag'}=$anrdat->auf_data_ag();
    if ($AnrDatRef->{'arch'}=$anrdat->auf_data_arch()) {  #wenn kein Architekt eingetragen dann 0
            $AnrDatRef->{'arch'}=$anrdat->auf_data_arch()}
            else{$AnrDatRef->{'arch'}=('-')}
       $AnrDatRef->{'bez'}=$anrdat->auf_data_bez();
       $AnrDatRef->{'pl'}=$anrdat->auf_data_projekt_leiter();
       $AnrDatRef->{'anzblt'}=$anrdat->anzahl_zeichnungen('all');
    if ($AnrDatRef->{'anzblt_ind'}=$anrdat->anzahl_zeichnungen('index')){ #wenn keine indexe vorhanden dann 0
                $AnrDatRef->{'anzblt_ind'}=$anrdat->anzahl_zeichnungen('index')}
                else{$AnrDatRef->{'anzblt_ind'}=('0')}
       $AnrDatRef->{'anzblt_no_ind'}=$anrdat->anzahl_zeichnungen('no_index');
    if ($AnrDatRef->{'ts'}=$anrdat->anzahl_zeichnungen('ts')) {
        $AnrDatRef->{'ts'}=$anrdat->anzahl_zeichnungen('ts')}
        else{$AnrDatRef->{'ts'}=('Kein Zng-Typ: ts vorhanden')}    
    return $AnrDatRef
}


#Zeichnungsdaten abfragen
sub zeichnungsdaten {
    my ($anr,$tx_zdat)=@_;
# Abfrage vorbereiten
my $sql = <<'SQL';
                    SELECT  zng_data_typ,      zng_data_znr,    zng_data_blatt,    zng_data_index, zng_data_beschrieb, zng_data_index_text, 
                            zng_data_massstab, zng_data_format, zng_data_Anstrich, zng_data_datum, zng_data_k_name,    zng_data_id
                    FROM zng_data
                    WHERE zng_data_anr = ?
SQL
    my $sth = $dbh->prepare($sql);
                                
#Abfrag ausführen
   $sth->execute($anr);

    my $r=1;
    while (my @v = $sth->fetchrow_array()){
        
        $tx_zdat->{"$r,0"} = "$v[0]";
        $tx_zdat->{"$r,1"} = "$v[1]";
        $tx_zdat->{"$r,2"} = "$v[2]";
        $tx_zdat->{"$r,3"} = "$v[3]";
        $tx_zdat->{"$r,4"} = "$v[4]";
        $tx_zdat->{"$r,5"} = "$v[5]";
        $tx_zdat->{"$r,6"} = "$v[6]";
        $tx_zdat->{"$r,7"} = "$v[7]";
        $tx_zdat->{"$r,8"} = "$v[8]";
        $tx_zdat->{"$r,9"} = "$v[9]";
        $tx_zdat->{"$r,10"} = "$v[10]";
        $tx_zdat->{"$r,11"} = "$v[11]";

        $r++;
    }
    $r--;
    $sth->finish;
 
    $tx_zdat->{rows} = $r;
    
    return $tx_zdat;
}






1;