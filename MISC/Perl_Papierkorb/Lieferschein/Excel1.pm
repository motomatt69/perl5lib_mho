package Lieferschein::Excel1;
use strict;
use Lieferschein::SQL qw(get_values);
use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);

$Win32::OLE::Warn = 3; #3 bedeutet Die on errors
#Excel Anwendung einbinden
my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
            || Win32::OLE->new('Excel.Application','Quit');
#excel display alerts abschalten
$Excel->{DisplayAlerts}=0;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(write_excel);


sub write_excel {
    my ($dat_ref, $func_ref) = @_;

#Bestehende Excel Datei öffnen
my $Book = $Excel->Workbooks->open('\\\\server-daten\AUFTRAG\080335_REA_Karlsruhe_AEEGraz\Lieferscheine\Annex 1 Packliste_org.xls');
my $sheet= $Book->Worksheets(1);
            $sheet->Activate(); 
    
# Kopfzeile eintragen und Blatt unter neuem Namen speichern
    my $out_pfad="\\\\server-daten\\AUFTRAG\\080335_REA_Karlsruhe_AEEGraz\\Lieferscheine\\Packliste\\";
    #for my $key (sort {$a <=> $b} keys %$dat_ref) {
        my $daten_ref = $dat_ref->{0};
            print $$daten_ref;
        if ($$daten_ref =~ m/^080335-(\d{5})(rev\d+);(\d{8});(\d+\.?\d*);(\d{4}-\d{2}-\d{2})$/) { #Kopfzeile filtern, PlNr, Gesgewicht und Datum matchen
            my $excelfile="Annex 1 Packliste_30045-$1_SW$3$2.xls";
            $excelfile=$out_pfad.$excelfile;
            $Book->Saveas($excelfile);
            $sheet->cells(9,1)->{value}="30045-$1$2"; #Packlistennummer eintragen
            $sheet->cells(10,1)->{value}="(SW-$3$2)"; #Lieferscheinnummer eintragen
            $sheet->cells(9,7)->{value}=$4;     #Gesamtgewicht eintragen
            $sheet->cells(9,9)->{value}=$5;     #Datum eintragen
        }else{
            print "Kopfzeile nicht akzeptiert, Administrator Fragen\n";
        }
    #}
#Erforderliche Zeilenanzahl ermitteln und entsprechend Zeilen in excelsheet einfügen
    
    my@keys = keys %$dat_ref; #Anzahl Datensätze
    my $anzahl= (scalar @keys) -1;
    
    if ($anzahl >29 and $anzahl < 77) {
        $sheet -> Range("A16:A30") -> EntireRow->Insert; #Fehlende Zeilen in excel einfügen
        $sheet -> Range("A16:A47") -> EntireRow->Insert;
    }elsif ($anzahl > 76) {
        $sheet -> Range("A16:A30") -> EntireRow->Insert; #Fehlende Zeilen in excel einfügen
        $sheet -> Range("A16:A47") -> EntireRow->Insert;
        my$Seiten = (sprintf "%d",(($anzahl-74)/47));
        my $i=0;
        while ($i <= $Seiten){
            $sheet -> Range("A15:A61") -> EntireRow->Insert; #Fehlende Zeilen in excel einfügen
            $i++;
        }
    }
    
#Hauptpositionen eintragen
    my $Fortschritt=0;
    my $Zeile = 13;
    for my $key (sort {$a <=> $b} keys %$dat_ref) {
        my $daten_ref = $dat_ref->{$key};    
        if ($key==0){
            next
        }else{
            #my @Zusatzwerte = get_values($daten_ref->[6]);#Zusatzwerte aus DB holen            
            $sheet->cells($Zeile,1)->{value}=$$daten_ref[0]; #Anzahl
            $sheet->cells($Zeile,2)->{value}="$$daten_ref[1] $$daten_ref[2]*$$daten_ref[3]*$$daten_ref[4]"; #Beschreibung und Abmessungen
            $sheet->cells($Zeile,6)->{value}=$$daten_ref[8]; #Bauteil nach Kunde
            my $Gewicht=$$daten_ref[5];
            if ($Gewicht =~ m/\d+.\d+/) {
                $Gewicht=~s/\./,/;    #Gewicht Punkt in Komma tauschen
            }
            $sheet->cells($Zeile,7)->{value}=$Gewicht;
            $sheet->cells($Zeile,9)->{value}=$$daten_ref[6];# Teilsystem
            $$daten_ref[9]=~ m/^EK540067\.(.+$)/;# Zeichnungsnummer Kunde
            $sheet->cells($Zeile,10)->{value}=$1;
            $sheet->cells($Zeile,11)->{value}=$$daten_ref[7]; #HPos Nummer
            $Zeile++;
            my $Fortschritt=(sprintf "%d",(($Zeile-13)/$anzahl)*100); #Fortschrittsbalken
            
            if ($func_ref) {
                &$func_ref($Fortschritt);
            }
            print "$Fortschritt%\n";
        }
    }
$Book->Save;
$Book=$Excel->Workbooks->Close();
print "saved\n";
}

1;