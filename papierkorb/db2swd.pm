package RDK8FT::db2swd;
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
use File::Spec;
use RDK8FT::MON_DB::MON;

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors


sub excel_fuellen{
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 1;
    
    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
    
    my $in_file = 'Monitoring swd.xls';
    my $in_path = File::Spec->catfile($dir, $in_file);
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets(1);
    my $maxr = $sheet->UsedRange->Rows->Count;
    
    $sheet->Range("B3:N$maxr")->ClearContents;
    $sheet->Range("V3:AA$maxr")->ClearContents;
    $sheet->Range("AA3:AC$maxr")->Clear;
    
    my $dbh = RDK8FT::MON_DB::MON->new();
        
    for my $z (3..$maxr) {
        my $alstom_id = $sheet->Cells($z,1)->{'Value'};
        print "aktualisieren $alstom_id\n";
        my ($rec) = $dbh->monitor->search({position => $alstom_id});
        my $cnt;
        if ($rec) {
            eintragen($sheet, $rec, $z);
        }
    }
    
    #Neueintrag
    my @recs = $dbh->monitor->search({in_excel => 0});
    my $cnt;
    foreach my $rec (@recs) {
        print "neueintrag ",$rec->position,"\n";
        $cnt++;
        my$z = $maxr + $cnt;
        $sheet->Range("A$z")->{'Value'} = $rec->position;
        eintragen($sheet, $rec, $z);
    }
        
    $book->Save;
    print "Fertig";
    $book->Close;
    $excel-> Quit;
}

sub eintragen{
    my ($sheet, $rec, $z) = @_;
    
     $sheet->Range("B$z")->{'Value'} = $rec->cube;
     $sheet->Range("C$z")->{'Value'} = $rec->mont_rel;
     $sheet->Range("D$z")->{'Value'} = $rec->erection;
     $sheet->Range("E$z")->{'Value'} = $rec->workshopdwg_de;
     $sheet->Range("F$z")->{'Value'} = $rec->actual_rev;
     $sheet->Range("G$z")->{'Value'} = $rec->fabricator;
     $sheet->Range("H$z")->{'Value'} = $rec->workshopdwg_fab;
     $sheet->Range("I$z")->{'Value'} = $rec->manufactured_rev;
     $sheet->Range("J$z")->{'Value'} = $rec->ft_del;
     $sheet->Range("K$z")->{'Value'} = $rec->ft_mod;
     $sheet->Range("L$z")->{'Value'} = $rec->difference_rev;
     $sheet->Range("M$z")->{'Value'} = $rec->info_bf;
     $sheet->Range("N$z")->{'Value'} = $rec->deli_loc;
     $sheet->Range("O$z")->{'Value'} = $rec->date_of_deli;
     $sheet->Range("P$z")->{'Value'} = $rec->fabricated_rev_bf;
     $sheet->Range("Q$z")->{'Value'} = $rec->difference_rev_bf;
     $sheet->Range("R$z")->{'Value'} = $rec->refodisp;
     $sheet->Range("S$z")->{'Value'} = $rec->new_bundle;
     $sheet->Range("T$z")->{'Value'} = $rec->date_of_outgoing_bf;
     $sheet->Range("U$z")->{'Value'} = $rec->info_from_bf;
     my $weight_de = $rec->weight_de;
     $weight_de =~ s/\./,/;
     $sheet->Range("V$z")->{'Value'} = $weight_de;
     my $weight_prog = $rec->weight_prog;
     $weight_prog =~ s/\./,/;
     $sheet->Range("W$z")->{'Value'} = $weight_prog;
     $sheet->Range("X$z")->{'Value'} = $rec->shipment1;
     $sheet->Range("Y$z")->{'Value'} = $rec->bundle;
     $sheet->Range("Z$z")->{'Value'} = $rec->deli_date_baust;
     $sheet->Range("AA$z")->{'Value'} = $rec->beastand;
     $sheet->Range("AA$z")->Interior->{ColorIndex} = $rec->color;
     $sheet->Range("AB$z")->{'Value'} = $rec->gewicht;
     $sheet->Range("AC$z")->{'Value'} = $rec->rev;
     
     $rec->in_excel(1);
     $rec->update();
}            
            
1;