package RDK8FT::ines2db;
use strict;
use RDK8FT::File::Paths;
use File::Spec;
use RDK8FT::MON_DB::MON;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::shop_status;
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

sub set_ines2db{
    my ($self, $in_file) = @_;
    
    my $dbh_mon = RDK8FT::MON_DB::MON->new();
    
    my $exc_ines_ref = $self->excel_auslesen($in_file);
    my @exc_ines = @$exc_ines_ref;
    my $anz_exc_ines = @exc_ines;
    
    foreach my $z (@exc_ines) {
        my ($pos, $beastand, $x_90) = ($z->[1], $z->[14], $z->[17]);
        my ($fabind, $bun, $dat) = ($z->[7], $z->[20], $z->[19]);
        my ($lsnr) = ($z->[21]);
        
        $self->printtrace("$pos\n");
        
        my ($lsdat);
        if ($lsnr){
            $lsdat = $self->lieferscheindatum($lsnr);
        }
        
        my $info_bf = ($beastand =~ m/keine ZNG keine STL/) ? 'no dwg' :
        ($beastand =~ m/\w/) ? undef : 'keine_ZNG';
        if ($x_90) {
            $info_bf = 'Fertigung';
            $self->printtrace("in Fertigung\n");
            RDK8FT::shop_status->shopstatus_exc2db($z)
        }
                
        my ($rec) = $dbh_mon->monitor->search({position => $pos});
        
        $rec->beastand($beastand);
        $rec->fabricated_rev_bf($fabind);
        $rec->refodisp($dat);
        $rec->new_bundle($bun);
        $rec->date_of_outgoing_bf($lsdat);
        $rec->info_from_bf($info_bf);
        $rec->update();
    }
}

sub excel_auslesen {
    my ($self, $in_file) = @_;
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 0;
    
    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
    
    my $in_path = File::Spec->catfile($dir, $in_file);
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets(1);
    $sheet->{AutoFilterMode} = 0;
    
    my $maxr = $sheet->UsedRange->Rows->Count;
    
    while (!$sheet->Range("A$maxr")->{'Value'}) {
        $maxr --;
    }
    
    my $excel_ines = $sheet->Range("A3:W$maxr")->{'Value'};
    
    $sheet->Range("A1")->AutoFilter;
    $sheet->Range("A1")->Select;
    $book->Save;
    $book->Close;
    $excel-> Quit;
    
    return $excel_ines;
}

sub lieferscheindatum{
    my ($self, $lsnr) = @_;

    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    
    my ($lieferschein) = $cdbh->lieferschein->search(nummer => $lsnr);
    my $lsdat = $lieferschein->datum();
    
    my ($yyyy, $mm, $dd) = $lsdat =~ m/(\d{4})-(\d{2})-(\d{2})/;
    
    $lsdat = $dd.'.'.$mm.'.'.$yyyy;
    
    return $lsdat;

}
    
#sub fabrev_und_bundle_ausrdk8db{
#    my (@exc_ines) = @_;
#    
#    my ($alsto, $ind, $bt);
#    
#    my $cdbh = RDK8FT::DB::RDK8FTP->new();
#    my $dbh = $cdbh->dbh();
#    
#    my %alstos = map {($_->[1] => $_)} @exc_ines;
#    
#    my $alstolist = join ',', (map{ $_->[1]} @exc_ines);
#     
#    my $sth = $dbh->prepare(qq(SELECT alstom_id, maxindex
#                            FROM v_bauteil2zeichnung_maxindex
#                            WHERE alstom_id in ($alstolist)));
#    $sth->execute();
#    $sth->bind_col (1, \$alsto);
#    $sth->bind_col (2, \$ind);
#    
#    #%alstos;
#    while ($sth->fetch) {
#        $alstos{$alsto}->[23] = $ind;        
#    }
#    
#    my ($bundle, $dat);
#    $sth = $dbh->prepare(qq(SELECT a.alstom_id, a.nummer, c.datum
#                         FROM v_bundlepos a, bundlepos b, bundle2bundlestatus c
#                         WHERE a.bundlepos_id = b.bundlepos_id
#                         AND b.bundle = c.bundle
#                         AND a.alstom_id in ($alstolist)));
#    $sth->execute();
#    $sth->bind_col (1, \$alsto);
#    $sth->bind_col (2, \$bundle);
#    $sth->bind_col (3, \$dat);
#    
#    
#    while ($sth->fetch){
#        $alstos{$alsto}->[24] = $bundle;
#        
#        
#        $dat = substr($dat, 0, 10);
#        $alstos{$alsto}->[25] = $dat;
#    }
#    
#    @exc_ines = ();
#    @exc_ines = map {$_} values %alstos; 
#    
#    return @exc_ines;
#}
        
        
1;
