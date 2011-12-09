package RDK8FT::db2alstom;
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
use File::Spec;
use RDK8FT::MON_DB::MON;
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

sub set_db2alstom{
    my ($self, $in_file) = @_;
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 1;
    
    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
    
    my $in_path = File::Spec->catfile($dir, $in_file);
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets(1);
    my $maxr = $sheet->UsedRange->Rows->Count;
    
    $sheet->Range("P6:Q$maxr")->ClearContents;
    $sheet->Range("S6:V$maxr")->ClearContents;
    
    my $dbh = RDK8FT::MON_DB::MON->new();
        
    for my $z (6..$maxr) {
        my $alstom_id = $sheet->Cells($z,1)->{'Value'};
        $self->printtrace("eintragen in alst $alstom_id\n");
        my ($rec) = $dbh->monitor->search({position => $alstom_id});
        my $cnt;
        if ($rec) {
            $sheet->Range("Q$z")->{'Value'} = $rec->fabricated_rev_bf;
            
            $sheet->Range("S$z")->{'Value'} = $rec->refodisp;
            $sheet->Range("T$z")->{'Value'} = $rec->new_bundle;
            $sheet->Range("U$z")->{'Value'} = $rec->date_of_outgoing_bf;
            $sheet->Range("V$z")->{'Value'} = $rec->info_from_bf;
        }
    }
       
    $book->Save;
    $self->printtrace("Fertig");
    $book->Close;
    $excel-> Quit;
}

            
1;