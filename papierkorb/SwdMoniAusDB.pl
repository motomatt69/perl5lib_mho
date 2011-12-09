#!/usr/bin/perl -w
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

my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                || Win32::OLE->new('Excel.Application','Quit');
$excel->{DisplayAlerts}=0;
#$excel->{Visible} = 1;

my $dir = RDK8FT::File::Paths->get_monitoring_dir();

my $in_file = 'Monitoring swd.xls';
my $in_path = File::Spec->catfile($dir, $in_file);

my $book = $excel->Workbooks->open($in_path);
my $sheet= $book->Worksheets(1);

my $maxr = $sheet->UsedRange->Rows->Count;

$sheet->Range("B5:N$maxr")->ClearContents;
$sheet->Range("V5:AA$maxr")->ClearContents;
$sheet->Range("AB5:AB$maxr")->Clear;

my $dbh = RDK8FT::MON_DB::MON->new();
my @data = $dbh->monitor->retrieve_all();

foreach my $dat (@data) {
    my $pos = $dat->position;
    for my $row (5..$maxr) {
        if ($sheet->Range("A$row")->{'Value'} == $pos) {
            $sheet->Range("B$row:C$row")->{'Value'} = [[2,3]];
            
        }
    }
}
        
            
            

$book->Save;
print "Fertig";
$excel-> Quit;
1;
