#!/usr/bin/perl -w
use strict;
use RDK8FT::DB::RDK8FTP;

use RDK8FT::File::Paths;

use RDK8FT::K;
my $konst = RDK8FT::K->new();
use bigint;

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors


#my $Kirchner_file = 'Kopie von Monitoring Kirchner.xls';
#my @zngs = x90aus_exc($Kirchner_file);
my @zngs = qw(21079-0208-00);
#my @zngs = hole_zeichnungen();

#Was soll geaendert werden:
#my $bit_change = $konst->fertig_fuer_av();
#my $bit_change = $konst->einzelteil();
#my $bit_change = $konst->stueckliste();
#my $bit_change = $konst->promix();
my $bit_change = $konst->maler();

for my $z (@zngs) {
    $z =~ s/_/-/g;
    print $z,"\n";
    #bit_loeschen($z, $bit_change);
    #bit_einfuegen($z, $bit_change);
}

sub bit_einfuegen{
    my ($zng, $bit_change) = @_;

    my ($znr, $ind) = $zng =~ m/(\d{5}-\d{4})-(\d{2})/;
    
    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    
    my ($vbt2z) = $cdbh->v_bauteilzeichnung->search({zeichnungsnummer => $znr,
                                                   indexnr => $ind});
    my $bt_id = $vbt2z->bauteil_id;
    
    
    my ($bt) = $cdbh->bauteilinfo->search ({bauteil => $bt_id});
    #my $status = $konst->einzelteil();
    my $stat_new = $bt->edit_bauteilstatus('|', $bit_change);
    
    print $bt->bauteilstatus,"\n";                   
    $bt->update();
}

sub bit_loeschen{
    my ($zng, $bitchange) = @_;

    #my $zng = '21321-0660-00';
    my ($znr, $ind) = $zng =~ m/(\d{5}-\d{4})-(\d{2})/;
    
    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    
    my ($vbt2z) = $cdbh->v_bauteilzeichnung->search({zeichnungsnummer => $znr,
                                                   indexnr => $ind});
    my $bt_id = $vbt2z->bauteil_id;
    my ($btinfo) = $cdbh->bauteilinfo->search(bauteil => $bt_id);
    my $btstat = $btinfo->bauteilstatus;
    
    my $bit_all = $konst->mask_all();
    
 #   my $bit_change = $konst->fertig_fuer_av();
    
    my $mask = $bit_all;
    $mask ^= $bit_change; #oder Verknüpfung)
    
    $btstat &= $mask;  #und Verknüpfung
    
    $btinfo->bauteilstatus($btstat);
    $btinfo->update();
}




sub hole_zeichnungen{

    my @dirs = ('c:', 'dummy', 'zng2');
    my $dir = File::Spec->catdir(@dirs);
    
    
    my @paths = glob ($dir.'\*.*');
    
    my @z1 = grep {$_ =~ m/\d{5}_\d{4}_\d{2}/} @paths;
    my @zngs = map {$_=~ m/(\d{5}_\d{4}_\d{2})/} @z1;
    
    
    my $dbh = RDK8FT::DB::RDK8FTP->new();
    my @favs = $dbh->v_bauteilstatus->search({pro => 1,
                                              fav => 0,
                                              ban => 0});
     for my $f (@favs){
        my $bt_id = $f->bauteil_id()->bauteil_id();
        my ($vbt2z) = $dbh->v_bauteilzeichnung->search(bauteil_id => $bt_id);
        my $znr = $vbt2z->zeichnungsnummer();
        $znr =~ s/-/_/;
        my $ind = $vbt2z->indexnr();
        my $zng = $znr.'_'.$ind;
        
        push @zngs, $zng;
     }
    
    my $cntzng = @zngs;
    
    return @zngs;
}

sub x90aus_exc{
    my ($in_file) = @_;
    
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
    print "maxr aus used range:  $maxr\n";
    
    while (!$sheet->Range("B$maxr")->{'Value'}) {
        $maxr --;
    }
    print "maxr korrigiert:  $maxr\n";        
    
    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    my $dbh = $cdbh->dbh();
    
    my $range = $sheet->Range("B3:R$maxr")->{'Value'};
    my @exc = @$range;
    
    my @zngrows = grep {$_->[16] eq 'x 90'} @exc;
    my @zngs;
    for my $z (@zngrows) {
        my $znr = $z->[4];
        my $ind = $z->[5];
        $ind = '0'.$ind if ($ind =~ m/\d/);
        my $zng = $znr.'-'.$ind;
        push @zngs, $zng
    }
    
    
    $sheet->Range("A1")->AutoFilter;
    $sheet->Range("A1")->Select;
    $book->Save;
    print "Fertig";
    $book->Close;
    $excel-> Quit;
    
    return @zngs;
    
}
