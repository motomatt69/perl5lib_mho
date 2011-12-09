package RDK8FT::WOCHENBERICHT;
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
use File::Spec;
use RDK8FT::MON_DB::MON;
use RDK8FT::alstom_id_aus_mon;

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

sub update{
    my ($self, $wb_file, $wb_kw) = @_;
    
    my %cubedat = datenbankabfrage_cubedat();
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
              || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    
    my $dir = RDK8FT::File::Paths->get_wochenbericht_dir();
    my $in_path = File::Spec->catfile($dir, $wb_file);
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets('2010_KW'.$wb_kw);
    
    my $maxr = $sheet->UsedRange->Rows->Count;
    
    my $colAref = $sheet->Range("A3:A$maxr")->{'Value'};
    my @colA = @$colAref;
    
    my (%cuberows, $rowcnt);
    for my $row (@colA){
        $rowcnt++;
        if (!defined $row->[0]){next};
        if ($row->[0] =~ m/\d{2}_\d/ or $row->[0] =~ m/MS\d/){
            $cuberows{$row->[0]} = $rowcnt + 2;
        }
    }

    my $misc = $cuberows{MS1};
    delete $cuberows{MS1};
    $cuberows{MISC} = $misc;
    
    for my $key (keys %cuberows){
           
        if (defined $cubedat{$key}){
            my $r = $cuberows{$key};
            
            $sheet->Range("AM$r:AM$r")->{Value} = $cubedat{$key}->[0];
            $sheet->Range("AO$r:AO$r")->{Value} = $cubedat{$key}->[1];
            $sheet->Range("AS$r:AS$r")->{Value} = $cubedat{$key}->[2];
            $sheet->Range("AT$r:AT$r")->{Value} = $cubedat{$key}->[3];
            $sheet->Range("AU$r:AU$r")->{Value} = $cubedat{$key}->[4];
            
            print "cube: $key; line: $cuberows{$key} wert: $cubedat{$key}->[0] wert: $cubedat{$key}->[1]\n";
        
        
        
        }
        my $dummy;
    }
        
    
    $sheet->Range("A1")->Select;
    $book->Save;
    print "Fertig";
    $book->Close;
    $excel-> Quit;
    my $dummy;
}

sub datenbankabfrage_cubedat{
        
    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    my $dbh = $cdbh->dbh();

    my %cubedat;   
    my ($cube, $menge, $beauf, $iav, $bun, $ls);
    my $sth = $dbh->prepare(qq(SELECT c.bezeichnung as cube, d.menge, a.auf,
                            a.iav, a.bl, a.ls
                            FROM  v_bauteilstatus a, bauteil2cube b, cube c,
                            bauteilinfo d
                            WHERE a.bauteil_id = b.bauteil
                            AND b.cube = c.cube_id
                            AND a.bauteil_id = d.bauteil    
                            AND NOT a.ban));
    $sth->execute();
    $sth->bind_columns(\$cube, \$menge, \$beauf, ,\$iav, \$bun, \$ls);
    
    while ($sth->fetch){
        if (defined $menge){
        $cubedat{$cube}->[0] += $menge;
        $cubedat{$cube}->[1] += $beauf * $menge;
        $cubedat{$cube}->[2] += $iav * $menge;
        $cubedat{$cube}->[3] += $bun * $menge;
        $cubedat{$cube}->[4] += $ls * $menge;
        }
    }
    
    return %cubedat;    
}
#sub excel_fuellen{
#    my ($self, $in_file) = @_;
#    
#    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
#                    || Win32::OLE->new('Excel.Application','Quit');
#    $excel->{DisplayAlerts}=0;
#    $excel->{Visible} = 1;
#    
#    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
#    
#    
#    my $in_path = File::Spec->catfile($dir, $in_file);
#    
#    my $book = $excel->Workbooks->open($in_path);
#    my $sheet= $book->Worksheets(1);
#    $sheet->{AutoFilterMode} = 0;
#    
#    my $maxr = $sheet->UsedRange->Rows->Count;
#    print "maxr aus used range:  $maxr\n";
#    
#    while (!$sheet->Range("A$maxr")->{'Value'}) {
#        $maxr --;
#    }
#    print "maxr korrigiert:  $maxr\n";        
#    
#    my $dbh_mon = RDK8FT::MON_DB::MON->new();
#    
#    
#    $maxr = neueintrag ($dbh_mon, $maxr, $sheet);    
#    print "maxr neu:  $maxr\n";
#    
#    aktualisieren($dbh_mon, $maxr, $sheet);
#    
#    $sheet->Range("A1")->AutoFilter;
#    $sheet->Range("A1")->Select;
#    $book->Save;
#    print "Fertig";
#    $book->Close;
#    $excel-> Quit;
#}
#        
#sub neueintrag {
#    my ($dbh_mon, $maxr, $sheet) = @_;
#    
#    my $range = $sheet->Range("A3:A$maxr")->{'Value'};
#    
#    my @tmp = @$range;
#    my @exc_col_a = map {$_->[0]} @tmp;
#    
#    my @mon_col_a = RDK8FT::alstom_id_aus_mon::get_alstom_ids($dbh_mon);        
#    
#    my %in_exc = map {$_ => 1} @exc_col_a;
#    my @nicht_in_exc = grep {!exists $in_exc{$_}} @mon_col_a;
#    my $anz_n_i_exc = @nicht_in_exc;
#    print "Nicht in excel: $anz_n_i_exc\n";
#    
#    my %in_mon = map {$_ => 1} @mon_col_a;
#    my @nicht_in_mon = grep {!exists $in_mon{$_}} @exc_col_a;
#    my $anz_n_i_mon = @nicht_in_mon;
#    print "Nicht in mon: $anz_n_i_mon\n";
#    #foreach my $val (@nicht_in_mon) {
#    #    print $val,"\n";
#    #}
#    
#    my $z = $maxr + 1;
#    foreach my $val (@nicht_in_exc) {
#        $sheet->Range("A$z")->{'Value'} = $val;
#        $z++;
#    }
#    
#    return $z - 1;
#}
#
#sub aktualisieren{
#    my ($dbh_mon, $maxr, $sheet) = @_;
#    
#    my $dbh_mon_sql = $dbh_mon->dbh();
#    my $dbh_rdk = RDK8FT::DB::RDK8FTP->new();
#    my $dbh_rdk_sql = $dbh_rdk->dbh();
#    
#    my $range = $sheet->Range("A3:A$maxr")->{'Value'};
#    
#    $sheet->Range("B3:M$maxr")->ClearContents;
#        
#    my @exc = @$range;
# 
#    my %exc = map {($_->[0] => $_)} @exc;
#    my @ids = keys %exc;
#    my $id_list = join "," , @ids;
#    
#    eintragen_aus_dbmon($id_list, $dbh_mon_sql, \%exc);
#    
#    eintragen_aus_v_bauteilzeichnung($id_list, $dbh_rdk_sql, \%exc);
#    
#    eintragen_aus_v_bauteil2termin($id_list, $dbh_rdk_sql, \%exc);
#    
#    eintragen_aus_v_alstom_id2guete($id_list, $dbh_rdk_sql, \%exc);
#    
#    eintragen_aus_v_bauteilstatus($id_list, $dbh_rdk_sql, \%exc);
#    
#    $sheet->Range("A3:M$maxr")->{'Value'} = \@exc;
#}
#    
#sub eintragen_aus_dbmon{
#    my ($id_list, $dbh_rdk_sql, $exc) = @_;
#    my ($alstom_id, $mon_rel, $zeichnungsnummer, $rev, $fab, $info_bf);
#    
#    my $sth_tab = $dbh_rdk_sql->prepare(qq{
#        SELECT position, mont_rel, workshopdwg_de, actual_rev, fabricator, info_bf
#        FROM monitor
#        WHERE position in ($id_list) 
#    });
#    
#    $sth_tab->execute();
#    $sth_tab->bind_columns(\$alstom_id, \$mon_rel, \$zeichnungsnummer, \$rev, \$fab, \$info_bf);
#       
#    while ($sth_tab->fetch()){
#        my $z = $exc->{$alstom_id};
#        @$z[1,3,4,10,11] = ($mon_rel, $zeichnungsnummer, $rev, $fab, $info_bf);
#    }
#    $sth_tab->finish;
#}            
#
#sub eintragen_aus_v_bauteilzeichnung{
#    my ($id_list, $dbh_rdk_sql, $exc) = @_;
#    my ($alstom_id, $zeichnungsnummer, $indexnr);
#    
#    my $sth_tab = $dbh_rdk_sql->prepare(qq{
#        SELECT alstom_id, zeichnungsnummer, indexnr
#        FROM v_alstom_id2zeichnungsnummer
#        WHERE alstom_id in ($id_list)
#    });
#    
#    $sth_tab->execute();
#    $sth_tab->bind_columns(\$alstom_id, \$zeichnungsnummer, \$indexnr);
#    
#    while ($sth_tab->fetch()){
#        my $z = $exc->{$alstom_id};
#        
#        @$z[3, 4] =  ($zeichnungsnummer, $indexnr);
#    }
#    $sth_tab->finish;
#    
#}
#
#sub eintragen_aus_v_bauteil2termin{
#    my ($id_list, $dbh_rdk_sql, $exc) = @_;
#    my ($alstom_id, $bezeichnung, $zeichnungsnummer, $beginn, $menge, $gewicht);
#    
#    my $sth_tab = $dbh_rdk_sql->prepare(qq{
#        SELECT alstom_id, bezeichnung, beginn, menge, gewicht
#        FROM v_bauteil2termin
#        WHERE alstom_id in ($id_list)
#    });
#    
#    $sth_tab->execute();
#    $sth_tab->bind_columns(\$alstom_id, \$bezeichnung, \$beginn, \$menge, \$gewicht);
#    
#    while ($sth_tab->fetch()){
#        my $z = $exc->{$alstom_id};
#        $gewicht =~ s/\./,/g;
#        @$z[2, 6, 7, 8] =  ($bezeichnung, $beginn, $menge, $gewicht);
#    }
#    $sth_tab->finish;
#    
#}
#
#sub eintragen_aus_v_alstom_id2guete{
#    my ($id_list, $dbh_rdk_sql, $exc) = @_;
#    my ($alstom_id, $guetebez) = @_;
#    
#    my $sth_tab = $dbh_rdk_sql->prepare(qq{
#        SELECT alstom_id, bezeichnung
#        FROM v_alstom_id2guete
#        WHERE alstom_id in ($id_list)
#    });
#    
#    $sth_tab->execute();
#    $sth_tab->bind_columns(\$alstom_id, \$guetebez);
#    
#    while ($sth_tab->fetch()){
#        my $z = $exc->{$alstom_id};
#        @$z[9] =  ($guetebez);
#    }
#    $sth_tab->finish;
#}
#
#sub eintragen_aus_v_bauteilstatus {
#    my ($id_list, $dbh_rdk_sql, $exc) = @_;
#    my ($alstom_id, $zng,  $stl, $et, $pro , $fav) = @_;
#    
#    my $sth_tab = $dbh_rdk_sql->prepare(qq{
#        SELECT alstom_id, zng, stl, et, pro, fav
#        FROM v_bauteilstatus
#        WHERE alstom_id in ($id_list)
#    });
#    
#    $sth_tab->execute();
#    $sth_tab->bind_columns(\$alstom_id, \$zng, \$stl, \$et, \$pro, \$fav);
#    
#    while ($sth_tab->fetch()){
#        my $z = $exc->{$alstom_id};
#        
#        
#        my $status =    ($zng == 0 and $stl == 0)  ? 'keine ZNG keine STL' :
#                        ($zng == 1 and $stl == 0)  ? 'stl Liste zu erstellen' :
#                        ($stl == 1 and $pro == 0)  ? 'in Promix einzuspielen' :
#                        ($pro == 1 and $et == 0) ? 'Einzelteile fehlen'     :
#                        ($pro == 1 and $et == 1 and $fav == 0) ? 'AV Unterlagen sammeln'  :
#                        ($fav == 1) ? 'fertig fuer AV'         : 'Fehler bei db2ines suchen';
#        
#        @$z[12] =  ($status);
#    }
#    $sth_tab->finish;
#}
##sub eintragen_aus_v_alstom_id2datei_stkliste {
##    my ($id_list, $dbh_rdk_sql, $exc) = @_;
##    my ($alstom_id, $verarbeitet) = @_;
##    
##    my $sth_tab = $dbh_rdk_sql->prepare(qq{
##        SELECT alstom_id, verarbeitet
##        FROM v_alstom_id2datei_stkliste
##        WHERE alstom_id in ($id_list)
##    });
##    
##    $sth_tab->execute();
##    $sth_tab->bind_columns(\$alstom_id, \$verarbeitet);
##    
##    while ($sth_tab->fetch()){
##        my $z = $exc->{$alstom_id};
##        
##        $verarbeitet =  ($verarbeitet == 0)  ? 'stl Liste zu erstellen' :
##                        ($verarbeitet == 1)  ? 'in Promix einzuspielen' :
##                        ($verarbeitet == 10) ? 'Einzelteile fehlen'     :
##                        ($verarbeitet == 15) ? 'AV Unterlegen sammeln'  :
##                        ($verarbeitet == 20) ? 'fertig fuer AV'         : 'Fehler bei db2ines suchen';
##        
##        @$z[12] =  ($verarbeitet);
##    }
##    $sth_tab->finish;
##}
##    
#    
#    
#    
#    
1;