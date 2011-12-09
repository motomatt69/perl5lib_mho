package RDK8FT::db2ines;
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
use File::Spec;
use RDK8FT::MON_DB::MON;
use RDK8FT::alstom_id_aus_mon;
use Patterns::Observer qw(:subject);

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

sub new{
    my ($class) = @_;
    
    return bless {}, $class;
}

sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}

sub get_prndat{
    my ($self) = @_;
    
    return $self->{prndat};
}

sub set_db2ines{
    my ($self, $in_file) = @_;
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 1;
    
    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
    
    
    my $in_path = File::Spec->catfile($dir, $in_file);
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets(1);
    $sheet->{AutoFilterMode} = 0;
    
    my $maxr = $sheet->UsedRange->Rows->Count;
    $self->printtrace("maxr aus used range:  $maxr\n");
    
    while (!$sheet->Range("B$maxr")->{'Value'}) {
        $maxr --;
    }
    $self->printtrace("maxr korrigiert:  $maxr\n");        
    
    my $dbh_mon = RDK8FT::MON_DB::MON->new();
    
    
    $maxr = $self->neueintrag ($dbh_mon, $maxr, $sheet);    
    $self->printtrace("maxr neu:  $maxr\n");
    
    $self->aktualisieren($dbh_mon, $maxr, $sheet);
    
    $sheet->Range("A1")->AutoFilter;
    $sheet->Range("A1")->Select;
    $book->Save;
    $self->printtrace("Fertig");
    $book->Close;
    $excel-> Quit;
}
        
sub neueintrag {
    my ($self, $dbh_mon, $maxr, $sheet) = @_;
    
    my $range = $sheet->Range("B3:B$maxr")->{'Value'};
    
    my @tmp = @$range;
    my @exc_col_a = map {$_->[0]} @tmp;
    
    my @mon_col_a = RDK8FT::alstom_id_aus_mon::get_alstom_ids($dbh_mon);        
    
    my %in_exc = map {$_ => 1} @exc_col_a;
    my @nicht_in_exc = grep {!exists $in_exc{$_}} @mon_col_a;
    my $anz_n_i_exc = @nicht_in_exc;
    $self->printtrace("Nicht in excel: $anz_n_i_exc\n");
    
    my %in_mon = map {$_ => 1} @mon_col_a;
    my @nicht_in_mon = grep {!exists $in_mon{$_}} @exc_col_a;
    my $anz_n_i_mon = @nicht_in_mon;
    $self->printtrace("Nicht in mon: $anz_n_i_mon\n");
        
    my $z = $maxr + 1;
    foreach my $val (@nicht_in_exc) {
        $sheet->Range("B$z")->{'Value'} = $val;
        $z++;
    }
    
    return $z - 1;
}

sub aktualisieren{
    my ($self, $dbh_mon, $maxr, $sheet) = @_;
    
    my $dbh_mon_sql = $dbh_mon->dbh();
    my $dbh_rdk = RDK8FT::DB::RDK8FTP->new();
    my $dbh_rdk_sql = $dbh_rdk->dbh();
    
    my $range = $sheet->Range("B3:B$maxr")->{'Value'};
    
    $sheet->Range("C3:O$maxr")->ClearContents;
    $sheet->Range("T3:V$maxr")->ClearContents;
        
    my @exc = @$range;
    
    map {$_->[21] = undef} @exc;
    
    my %exc = map {($_->[0] => $_)} @exc;
    my @ids = keys %exc;
    my $id_list = join "," , @ids;
    
    eintragen_aus_dbmon($id_list, $dbh_mon_sql, \%exc);
    
    eintragen_aus_v_bauteil2zeichnung_maxindex($id_list, $dbh_rdk_sql, \%exc);
    
    eintragen_aus_v_bauteil2cube($id_list, $dbh_rdk_sql, \%exc);
    
    eintragen_aus_v_alstom_id2guete($id_list, $dbh_rdk_sql, \%exc);
    
    eintragen_aus_v_bauteilstatus($id_list, $dbh_rdk_sql, \%exc);
    
    fabrev_und_bundle_ls_ausrdk8db($id_list, $dbh_rdk_sql, \%exc);
    
    montagesequenz_ausrdk8db($id_list, $dbh_rdk_sql, \%exc);
    
    entfallene_aus_v_bauteil2altmonitoringliste($id_list, $dbh_rdk_sql, \%exc);
    
    my @exc_p1 = map {[splice @$_, 0, 14]} @exc;
    my @exc_p2 = map {[splice @$_, 4, 3]} @exc;
    
    
    $sheet->Range("B3:O$maxr")->{'Value'} = \@exc_p1;
    $sheet->Range("T3:V$maxr")->{'Value'} = \@exc_p2;
   
    my $dummy;
}
    
sub eintragen_aus_dbmon{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $mon_rel, $zeichnungsnummer, $rev, $fab, $info_bf, $lfdnr);
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT position, mont_rel, workshopdwg_de, actual_rev, fabricator, info_bf
        FROM monitor
        WHERE position in ($id_list) 
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$mon_rel, \$zeichnungsnummer, \$rev, \$fab, \$info_bf);
       
    while ($sth_tab->fetch()){
        $lfdnr ++;
        my $z = $exc->{$alstom_id};
        @$z[1,4,5,11,12] = ($mon_rel, $zeichnungsnummer, $rev, $fab, $info_bf, $lfdnr); 
    }
    $sth_tab->finish;
}            

sub eintragen_aus_v_bauteil2zeichnung_maxindex{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $zeichnungsnummer, $maxindex);
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT alstom_id, zeichnungsnummer, maxindex
        FROM v_bauteil2zeichnung_maxindex
        WHERE alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$zeichnungsnummer, \$maxindex);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        
        @$z[4, 5] =  ($zeichnungsnummer, $maxindex);
    }
    $sth_tab->finish;
    
}

sub eintragen_aus_v_bauteil2cube{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $cube, $zeichnungsnummer, $menge, $gewicht);
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT alstom_id, cube, menge, gewicht
        FROM v_bauteil2cube
        WHERE alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$cube, \$menge, \$gewicht);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        $gewicht =~ s/\./,/g;
        @$z[2, 8, 9] =  ($cube, $menge, $gewicht);
    }
    $sth_tab->finish;
    
}

sub eintragen_aus_v_alstom_id2guete{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $guetebez) = @_;
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT alstom_id, bezeichnung
        FROM v_alstom_id2guete
        WHERE alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$guetebez);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        @$z[10] =  ($guetebez);
    }
    $sth_tab->finish;
}

sub eintragen_aus_v_bauteilstatus {
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $zng,  $stl, $et, $pro , $fav) = @_;
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT alstom_id, zng, stl, et, pro, fav
        FROM v_bauteilstatus
        WHERE alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$zng, \$stl, \$et, \$pro, \$fav);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        
        
        my $status =    ($zng == 0 and $stl == 0)  ? 'keine ZNG keine STL' :
                        ($zng == 1 and $stl == 0)  ? 'stl Liste zu erstellen' :
                        ($stl == 1 and $pro == 0)  ? 'in Promix einzuspielen' :
                        ($pro == 1 and $et == 0) ? 'Einzelteile fehlen'     :
                        ($pro == 1 and $et == 1 and $fav == 0) ? 'AV Unterlagen sammeln'  :
                        ($fav == 1) ? 'fertig fuer AV'         : 'Fehler bei db2ines suchen';
        
        @$z[13] =  ($status);
    }
    $sth_tab->finish;
}

sub fabrev_und_bundle_ls_ausrdk8db{
    my ($id_list, $dbh, $exc) = @_;
    my ($alstom_id, $ind);
     
    my $sth = $dbh->prepare(qq(SELECT alstom_id, maxindex
                            FROM v_bauteil2zeichnung_maxindex
                            WHERE alstom_id in ($id_list)));
    $sth->execute();
    $sth->bind_col (1, \$alstom_id);
    $sth->bind_col (2, \$ind);
    
    while ($sth->fetch) {
        my $z = $exc->{$alstom_id};
        @$z[6] =  ($ind);       
    }
    
    my ($bundle, $dat);
    $sth = $dbh->prepare(qq(SELECT a.alstom_id, a.nummer, c.datum
                         FROM v_bundlepos a, bundlepos b, bundle2bundlestatus c
                         WHERE a.bundlepos_id = b.bundlepos_id
                         AND b.bundle = c.bundle
                         AND a.alstom_id in ($id_list)));
    $sth->execute();
    $sth->bind_col (1, \$alstom_id);
    $sth->bind_col (2, \$bundle);
    $sth->bind_col (3, \$dat);
    
    while ($sth->fetch) {
        my $z = $exc->{$alstom_id};
        @$z[19] =  ($bundle);
        $dat = substr($dat, 0, 10);
        @$z[18] =  ($dat);
    }
    
    my ($lsnr);
    $sth = $dbh->prepare(qq(SELECT a.alstom_id, d.nummer
                        FROM bauteil a, bundlepos b, bundle2lieferschein c, lieferschein d
                        WHERE alstom_id IN ($id_list)
                        AND a.bauteil_id = b.bauteil
                        AND b.bundle = c.bundle
                        AND c.lieferschein = d.lieferschein_id));
    $sth->execute();
    $sth->bind_col (1, \$alstom_id);
    $sth->bind_col (2, \$lsnr);
    while ($sth->fetch) {
        my $z = $exc->{$alstom_id};
        @$z[20] =  ($lsnr);
    }    
}

sub montagesequenz_ausrdk8db{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $seq) = @_;
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
                                SELECT c.alstom_id, a.bezeichnung
                                FROM montagesequenz a, bauteilinfo b, bauteil c
                                WHERE a.montagesequenz_id = b.montagesequenz
                                AND b.bauteil = c.bauteil_id
                                AND alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$seq);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        @$z[3] =  ($seq);
    }
    $sth_tab->finish;   
}

sub entfallene_aus_v_bauteil2altmonitoringliste{
    my ($id_list, $dbh_rdk_sql, $exc) = @_;
    my ($alstom_id, $entfall_moni);
    
    my $sth_tab = $dbh_rdk_sql->prepare(qq{
        SELECT alstom_id, monitoringliste
        FROM v_bauteil2altmonitoringliste
        WHERE alstom_id in ($id_list)
    });
    
    $sth_tab->execute();
    $sth_tab->bind_columns(\$alstom_id, \$entfall_moni);
    
    while ($sth_tab->fetch()){
        my $z = $exc->{$alstom_id};
        @$z[2,9] =  ('entf', undef)
    }
    $sth_tab->finish;
    
}
1;