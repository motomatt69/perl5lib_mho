package main;
#!/usr/bin/perl -w
use strict;
use DBI;
use DB::Archiv;
use Zeitmessung::Zeitmessung;

my $GesZeit = Zeitmessung->new();

my $dbh = datenbankhandleholen();

my $Zeit_anr_listen = Zeitmessung->new();
&alle_auftraege_listen();
$Zeit_anr_listen->set_ende();

my $anr = '090171';

my $Zeit_anrdatobj_holen = Zeitmessung->new();
my $anrdatobj = auftragsdatenobjektholen($anr);
$Zeit_anrdatobj_holen->set_ende();

my $Zeit_anrdatdrucken = Zeitmessung->new();
&anrdat_drucken($anrdatobj);
$Zeit_anrdatdrucken->set_ende();

#Zeichnungen_listen#############################################################
my $Zeit_znr_pro_anr_drucken_cdbi = Zeitmessung->new();
&zeichnungen_pro_auftrag_drucken_cdbi($anrdatobj);
$Zeit_znr_pro_anr_drucken_cdbi -> set_ende();

my $Zeit_znr_pro_anr_drucken_methode = Zeitmessung->new();
#&zeichnungen_pro_auftrag_drucken_methode($anr);
$Zeit_znr_pro_anr_drucken_methode -> set_ende();

my $Zeit_znr_pro_anr_drucken_direkt = Zeitmessung->new();
&zeichnungen_pro_auftrag_drucken_direkt($anr);
$Zeit_znr_pro_anr_drucken_direkt -> set_ende();

#Verschiedene Abfragen##########################################################
my $Zeit_anstrich_pro_anr_drucken = Zeitmessung->new();
&anstriche_pro_auftrag_drucken($anrdatobj);
$Zeit_anstrich_pro_anr_drucken -> set_ende();

my $Zeit_dateien_pro_anr_drucken_cdbi = Zeitmessung->new();
&Dateien_pro_auftrag_drucken_cdbi($anrdatobj);
$Zeit_dateien_pro_anr_drucken_cdbi -> set_ende();

my $Zeit_dateien_pro_anr_drucken_direkt = Zeitmessung->new();
&Dateien_pro_auftrag_drucken_direkt($anr);
$Zeit_dateien_pro_anr_drucken_direkt -> set_ende();

#Alles mögliche zählen##########################################################
my $Zeit_zaehlen = Zeitmessung->new();
&auftraege_zaehlen();
&zeichnungen_zaehlen();
$Zeit_zaehlen -> set_ende();

#Übersichten erstellen
my $Uebersichten_erstellen = Zeitmessung->new();
&Eintrager_Hitliste();
&Eintraege_letzte_5_Tage();
&Auftragshitliste();
&Jahreshitliste();
$Uebersichten_erstellen -> set_ende();
$GesZeit->set_ende();

#Zeiten ausdrucken
print "\nZeiten:\n";
printf "Aufträge auflisten und zählen: %.3f s\n", $Zeit_anr_listen->get_dauer;
print "Auftrag: $anr\n";
printf "Auftragsdaten holen: %.3f s\n", $Zeit_anrdatobj_holen->get_dauer;
printf "Auftragsdaten auflisten: %.3f s\n", $Zeit_anrdatdrucken->get_dauer;
printf "Zeichnungen des Auftrages auflisten(cdbi): %.3f s\n", $Zeit_znr_pro_anr_drucken_cdbi->get_dauer;
printf "Zeichnungen des Auftrages auflisten(methode): %.3f s\n", $Zeit_znr_pro_anr_drucken_methode->get_dauer;
printf "Zeichnungen des Auftrages auflisten(direkt): %.3f s\n", $Zeit_znr_pro_anr_drucken_direkt->get_dauer;
printf "Anstriche des Auftrages auflisten: %.3f s\n", $Zeit_anstrich_pro_anr_drucken->get_dauer;
printf "Dateien des Auftrages auflisten(cdbi): %.3f s\n", $Zeit_dateien_pro_anr_drucken_cdbi->get_dauer;
printf "Dateien des Auftrages auflisten(direkt): %.3f s\n", $Zeit_dateien_pro_anr_drucken_direkt->get_dauer;
printf "Alles mögliche zählen: %.3f s\n", $Zeit_zaehlen->get_dauer;
printf "Übersichten erstellen: %.3f s\n", $Uebersichten_erstellen ->get_dauer;
printf "Verbrauchte GesamtZeit: %.3f s\n", $GesZeit->get_dauer;

################################################################################

sub datenbankhandleholen {
    DB::Archiv->get_db_handle;
}

sub alle_auftraege_listen {
#Abfrage vorbereiten
my $sql = <<'SQL';
    SELECT auf_data_anr
    FROM auf_data
SQL
    my $sth = $dbh->prepare($sql);
#   Abfrag ausführen
    $sth->execute;
    while (my @val = $sth->fetchrow_array()){
    print $val[0],"\n";
    }   
    $sth->finish;
}

sub auftragsdatenobjektholen {
    my ($anr) = @_;
    my $anrdatobj = DB::Archiv->get_auftrag($anr);
    return $anrdatobj
}
    
sub anrdat_drucken {
    my ($anrdatobj) = @_;
    print "Auftragsnummer: ",$anrdatobj->auf_data_anr(),"\n";
    print "Auftraggeber: ",$anrdatobj->auf_data_ag(),"\n";
    print "Architekt: ",$anrdatobj->auf_data_arch(),"\n";
    print "Bezeichnung: ",$anrdatobj->auf_data_bez(),"\n";
    print "Projektleiter: ",$anrdatobj->auf_data_projekt_leiter(),"\n";
}

sub zeichnungen_pro_auftrag_drucken_cdbi {
    my ($anrdatobj) = @_;
    my $it = $anrdatobj->zng_data_s();
    while (my $zng = $it->next()) {
        print $zng->zng_data_znr(),"_",$zng->zng_data_blatt(),"_",$zng->zng_data_index(),"  ",$zng->zng_data_beschrieb(),"\n";
    }
}


sub zeichnungen_pro_auftrag_drucken_methode {
    my($anr)=@_;
    my $it = DB::Archiv->get_zeichnung(anr => $anr);
    while (my $zng = $it->next()) {
        print $zng->zng_data_znr(),"_",$zng->zng_data_blatt(),"_",$zng->zng_data_index(),"  ",$zng->zng_data_beschrieb(),"\n";
    }
}
    
    
    
sub zeichnungen_pro_auftrag_drucken_direkt {
    my ($anr) = @_;
# Abfrage vorbereiten
    my $sql = <<'SQL';
                    SELECT concat( zng_data_typ, '-', zng_data_znr, '-',
                    zng_data_blatt, '-', zng_data_index),
                    zng_data_beschrieb, zng_data_index_text, 
                    zng_data_massstab, zng_data_format,
                    zng_data_Anstrich, zng_data_datum, zng_data_k_name, zng_data_id
                    FROM zng_data
                    WHERE zng_data_anr = ?
SQL
    my $sth = $dbh->prepare($sql);
       $sth->execute($anr);
    while (my @val = $sth->fetchrow_array()){
      print "________\n";
      print "$val[0], $val[1], $val[2], $val[3], $val[4], $val[5], $val[6], $val[7], $val[8], $val[9], $val[10]\n";
    }
    $sth->finish;
}
    
 

sub anstriche_pro_auftrag_drucken {
    my ($anrdatobj) = @_;
    my $it = $anrdatobj->auf_anstrich_s();
    while (my $anstrich = $it->next()) {
        print $anstrich->auf_anstrich_bez,"\n";
    }
}
    
sub Dateien_pro_auftrag_drucken_cdbi {
    my($anrdatobj)=@_;
    my $it = $anrdatobj->zng_file_s;
    while (my $zf = $it->next()) {
        print "Plotfile ", $zf->zng_file_path(),"\n";
    }
}

sub Dateien_pro_auftrag_drucken_direkt {
    my($anr)=@_;
my $sql = <<'SQL';
    SELECT zng_files_path
    FROM zng_files
    WHERE zng_files_anr = ?
SQL
    my $sth = $dbh->prepare($sql);
    $sth->execute($anr);
    while (my @val = $sth->fetchrow_array()){
        print "$val[0]\n";
    }
    $sth->finish;
}
######################################################################################################################    
sub auftraege_zaehlen {
my $sql = <<'SQL';
    SELECT COUNT(*)
    FROM auf_data
SQL
    my $sth = $dbh->prepare($sql);
#   Abfrag ausführen
    $sth->execute;
    print $sth->fetchrow_array()," Aufträge\n";
    $sth->finish;
}

sub zeichnungen_zaehlen {
# Blätter zählen
my $sql = <<'SQL';
    SELECT COUNT(*)
    FROM zng_data
SQL
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    my $blaetter =  $sth->fetchrow_array();
    $sth->finish;
#Zeichnungen zählen
    $sql = <<'SQL';
    SELECT COUNT(*)
    FROM zng_data
    WHERE zng_data_blatt = '01'
SQL
    $sth = $dbh->prepare($sql);
    $sth->execute;
    my $zeichnungen =  $sth->fetchrow_array();
    $sth->finish;
#Indexblätter zählen
    $sql = <<'SQL';
    SELECT COUNT(*)
    FROM zng_data
    WHERE zng_data_index > '00'
SQL
    $sth = $dbh->prepare($sql);
    $sth->execute;
    my $Indexblaetter =  $sth->fetchrow_array();
    print $zeichnungen," Zeichnungen\n";
    print $blaetter," Blätter\n";
    print $Indexblaetter," Indexblätter\n";
    $sth->finish;
}

sub Eintrager_Hitliste {
my $sql = <<'SQL';
    SELECT zng_data_k_name, COUNT(zng_data_k_name) AS eintraege FROM zng_data
    GROUP BY zng_data_k_name
    ORDER BY eintraege DESC
SQL
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    while (my @val = $sth->fetchrow_array()){
        print "$val[0]: $val[1] Blätter\n";
    }
    $sth->finish;
}

sub Eintraege_letzte_5_Tage{
my $sql = <<'SQL';
    SELECT      zng_data_datum, zng_data_anr, 
		concat( zng_data_typ, '-', zng_data_znr, '-', zng_data_blatt, '-', zng_data_index),
		zng_data_beschrieb, zng_data_k_name
    FROM        zng_data
    WHERE       zng_data_datum > DATE_SUB(CURDATE(),INTERVAL 5 DAY)
    ORDER BY    zng_data_datum DESC, zng_data_anr, zng_data_znr, zng_data_blatt, zng_data_index
SQL
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    while (my @val = $sth->fetchrow_array()){
        printf "%12s", $val[0];
        printf "%7s", $val[1];
        printf "%17s", $val[2];
        printf "%70s", $val[3];
        printf "%10s\n", $val[4];
    }
    $sth->finish;
}

sub Auftragshitliste{
my $sql = <<'SQL';
    SELECT   Z.zng_data_anr, A.auf_data_bez, COUNT(Z.zng_data_anr) AS eintraege
    FROM zng_data Z, auf_data A
    WHERE Z.zng_data_anr = A.auf_data_anr
    GROUP BY Z.zng_data_anr 
    ORDER BY eintraege DESC, Z.zng_data_anr DESC
SQL
   my $sth = $dbh->prepare($sql);
   $sth->execute;
   while (my @val = $sth->fetchrow_array()){
        printf "%10s", $val[0];
        printf "%50s", $val[1];
        printf "%6s\n", $val[2];
   }
   $sth->finish;
}

sub Jahreshitliste {
my $sql = <<'SQL';
    SELECT zng_data_datum, COUNT(*), DATE_FORMAT(zng_data_datum,'%Y')
    FROM   zng_data
    GROUP BY YEAR(zng_data_datum)
    ORDER BY zng_data_datum DESC
SQL
    my $sth = $dbh->prepare($sql);
    $sth->execute;
    while (my @val = $sth->fetchrow_array()){
        printf "%6s", $val[2];
        printf "%6s\n", $val[1];
    }
    $sth->finish;
}    

1;

