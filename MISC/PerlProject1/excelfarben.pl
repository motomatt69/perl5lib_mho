#!/usr/bin/perl -w
use strict;
use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
use File::Spec;
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors
##Name der exceldatei
my $excelfile = 'c:\dummy\ole_excelfarben.xls';

#Excel Anwendung einbinden
my $excel = Win32::OLE->GetActiveObject('Excel.Application')
            || Win32::OLE->new('Excel.Application','Quit');

#excel display alerts abschalten
$excel->{DisplayAlerts}=0;
##Neue Exceldatei anlegen
my $Book = $excel->Workbooks->Add();
$Book->Saveas($excelfile);

#Tabellenblatt aktivieren
my $sheet1= $Book->Worksheets(1);
$sheet1->Activate();
##Tabellenblatt umbennen
$sheet1->{Name}="excelfarben";

#Zellen füllen und einfärben und Schriftart fett
for my $Zeile (1..50) {
    $sheet1->Cells($Zeile,1)->{Value}=$Zeile;
    $sheet1->Cells($Zeile,2)->Interior->{ColorIndex}=$Zeile;
}

#abspeichern
$Book->Save;
print "Fertig";
#Excel beenden
$excel    -> Quit;