#!/usr/bin/perl -w
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
#use DBI;
#use Spreadsheet::ParseExcel;
#use Spreadsheet::DataFromExcel;
use File::Copy;
use File::Spec;
use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                || Win32::OLE->new('Excel.Application','Quit');
$excel->{DisplayAlerts}=0;


my $dir = RDK8FT::File::Paths->get_monitoring_dir();

my $in_file = 'Monitoring swd.xls';
my $in_path = File::Spec->catfile($dir, $in_file);

my $alst_book = $excel->Workbooks->open($in_path);
my $sheet1= $alst_book->Worksheets(1);

my $maxr = $sheet1->UsedRange->Rows->Count;
#$maxr = 50;
my $alstom_ids_ref = $sheet1->Range("A5:A$maxr")->{'Value'};

my @alstom_ids = @$alstom_ids_ref;
    

my $zeile = 5;
foreach my $val_ref (@alstom_ids) {
    print "zeile: $zeile    ";
    my $alstom_id = $val_ref->[0];
    next if !($alstom_id);
    print "$alstom_id   ";
    
    my $gew;
    my ($v_bt_inf) = RDK8FT::DB::RDK8FTP::v_bauteilinfo->search(alstom_id => $alstom_id);
    if ($v_bt_inf) {
        $gew = $v_bt_inf->gewicht();
    }
    if ($gew) {$gew = sprintf ("%.f", $gew)};
    #if ($gew) {($gew) = $gew =~ m/(\d+)/}; #Pkt durch Komma ersetzen wegen excel
    
    my ($it) = RDK8FT::DB::RDK8FTP::v_bauteilzeichnung->search(alstom_id => $alstom_id);
    if ($it) {
        my $znr = $it->zeichnungsnummer;
        $znr =~ s/-/_/;
        my ($datei) = RDK8FT::DB::RDK8FTP::datei->search_like(path => '%'.$znr.'%'.'txt');
        if ($datei) {
            my $ver = $datei->verarbeitet;
            my $path = $datei->path;
            my $endung = substr ($path,-4,4);
                if ($endung eq '.txt') {
                
                my ($text, $color)
                = ($ver == 0)
                ? ('Stl-Liste noch nicht erstellt',45)
                
                : ($ver == 1)
                ? ('Stl-Liste zum Einspielen in Promix bereit',44)
                
                : ($ver == 10)
                ? ('Promix eingespielt, Einzelteilzeichnungen fehlen', 26)
                
                : ($ver == 15)
                ? ('Promix eingespielt, Einzelteilzeichnungen vorhanden', 43)
                
                : ($ver == 20)
                ? ('Fertig fuer AV', 43)
                
                : ('Fehler', 3);
            
            
            $sheet1->Cells($zeile, 19)->{Value} = $gew.' kg';
            $sheet1->Cells($zeile, 24)->{Value} = $alstom_id;
            $sheet1->Cells($zeile, 25)->{Value} = $text;
            $sheet1->Cells($zeile, 25)->Interior->{ColorIndex} = $color if $color;
            print "$text\n";
            }
        }
        else{
            $sheet1->Cells($zeile, 19)->{Value} = '$gew kg';
            $sheet1->Cells($zeile, 24)->{Value} = $alstom_id;
            $sheet1->Cells($zeile, 25)->{Value} = 'keine Stückliste';
            $sheet1->Cells($zeile, 25)->Interior->{ColorIndex} = 40;
            print "keine Stückliste\n";
        }
    }
    else{
        $sheet1->Cells($zeile, 24)->{Value} = $alstom_id;
        $sheet1->Cells($zeile, 19)->{Value} = 'Zng fehlt';
        print "nix\n";
    }
    
    
    $zeile++;
}


$alst_book->Save;
print "Fertig";
$excel-> Quit;
1;
