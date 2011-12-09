#!/usr/bin/perl -w
use strict;
use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
use File::Spec;
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors
##Name der exceldatei
my $excelfile = 'ole_exceltest.xls';

#Excel Anwendung einbinden
my $excel = Win32::OLE->GetActiveObject('Excel.Application')
            || Win32::OLE->new('Excel.Application','Quit');

#excel display alerts abschalten
$excel->{DisplayAlerts}=0;
##Neue Exceldatei anlegen
#my $Book = $excel->Workbooks->Add();
#$Book->Saveas($excelfile);


#Bestehende Excel Datei öffnen
my $path = File::Spec->catfile ('c:\dummy', $excelfile);
my $Book = $excel->Workbooks->open($path);
#$Book->Saveas('c:\dummy\test2.xls');
#Tabellenblatt aktivieren
my $sheet1= $Book->Worksheets(1);
my $sheet2= $Book->Worksheets(2);
$sheet1->Activate();
##Tabellenblatt umbennen
$sheet1->{Name}="Perlsheet1";
$sheet2->{Name}="Perlsheet2";

#Zellen füllen und einfärben und Schriftart fett
for my $Zeile (1..10) {
    $sheet1->Cells($Zeile,1)->{Value}=$Zeile+10;
    $sheet1->Cells($Zeile,2)->Interior->{ColorIndex}=$Zeile;
    
}
$sheet1->Cells(20,2)->Select;
$sheet1->Cells(20,2)->{Value} = 'Text';
$sheet1->Cells(20,2)->Interior->{ColorIndex}=30;
$sheet1->Cells(20,2)->Font->{Size} = 16;
$sheet1->Cells(20,2)->Font->{ColorIndex} = 20;

#Letzte Zeile ermitteln 
my $LetzteZeile = $sheet1->UsedRange->Rows->Count;
print $LetzteZeile."\n";

#Aktuelle Selection holen
my $ActiveSheetName = $Book->ActiveSheet->Name;
print $ActiveSheetName,"\n";

$sheet2->Activate;
$ActiveSheetName = $Book->ActiveSheet->Name;
print $ActiveSheetName,"\n";

$sheet1->Activate;
$ActiveSheetName = $Book->ActiveSheet->Name;
print $ActiveSheetName,"\n";

#my $AktiveZeileReihe = $sheet1->Selection->Row;
#print $AktiveZeileReihe;
#Zeilen einfügen
$sheet1 -> Range("A1:A10") -> EntireRow->Insert;

#Zeilen kopieren
my$zeile=3;
$sheet1->Range("A1:A2")->Copy;
$sheet1->Cells(3,3)->PasteSpecial;

$sheet1->Cells(1,1)->Select;
$Book->Save;



#abspeichern
$Book->Save;
print "Fertig";
#Excel beenden
$excel    -> Quit;