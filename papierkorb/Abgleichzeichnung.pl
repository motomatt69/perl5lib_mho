#!/usr/bin/perl -w
use strict;

use RDK8FT::DB::RDK8FTP;
use DBI;
use Spreadsheet::ParseExcel;

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);

use File::Copy;

my $dbh = DBI->connect('dbi:AnyData(RaiseError=>1):');
$dbh->do('CREATE TABLE Liste (zeile TEXT, znr TEXT, ind TEXT, datei_id TEXT, zeichnung_id TEXT, vz_id TEXT)');
my $sth = $dbh->prepare('INSERT INTO Liste (zeile, znr, ind, datei_id, zeichnung_id, vz_id) VALUES (?, ?, ?, ?, ?, ?)');
my $stf = $dbh->prepare('SELECT zeile, znr, ind, datei_id, zeichnung_id, vz_id FROM Liste');# WHERE datei_id = 0 or zeichnung_id = 0');
my $parser = Spreadsheet::ParseExcel->new();
my $workbook = $parser->Parse('C:/dummy/090468/Wendeler.xls');
my $ws = $workbook->Worksheet('Tabelle1');

my $workbook1 = "C:\\dummy\\090468\\Wendeler_rev1.xls";
    copy($workbook->{File}, $workbook1) or die "Copy failed $!"; 


my ($minr, $maxr) = $ws->row_range();

#$maxr = 50;

for my $zeile (13 .. $maxr) {
    my $c = $ws->get_cell($zeile, 0);
    last if !$c;
    my $znr1 = $c->Value();
    $znr1 =~ s/[\/]/_/g;
    $znr1 =~ s/\W//g;
    
    $c = $ws->get_cell($zeile, 1);
    my $znr2 = $c->Value();
    $znr2 =~ s/\s*//g;
    
    $c = $ws->get_cell($zeile, 2);
    my $ind  = $c->Value();
    
    my $dateiname = sprintf '%s_%04d_%02d', $znr1, $znr2, $ind;
    
    
    $znr1 =~ s/\d+_//;
    my $znr = sprintf '%05d-%04d', $znr1, $znr2;
    print "$zeile:  "."$znr\n";
    
    my @dat = RDK8FT::DB::RDK8FTP::datei->search_like(
        path => '%' . $dateiname . '%pdf',
    );
    
    my ($zng_aus_Mon) = RDK8FT::DB::RDK8FTP::zeichnung->search(
        zeichnungsnummer => $znr,
        #indexnr          => $ind,
    );
    
    
    my ($zin) = RDK8FT::DB::RDK8FTP::zeichnungsindex->search(
        zeichnung => $zng_aus_Mon->id(),
        {order_by => 'indexnr DESC'}
                                                            ) if $zng_aus_Mon;
    
    
    my $dat = @dat;
    my $z_vorh = $zng_aus_Mon ? 1 : 0;
    my $i_vorh = $zin ? sprintf '%02d', $zin->indexnr() : q{};
    #my $vzg = @vzg;
    $sth->execute($zeile, $znr, $ind, $dat, $z_vorh, $i_vorh);
}

$stf->execute();

$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                || Win32::OLE->new('Excel.Application','Quit');

    $excel->{DisplayAlerts}=0;
    my $Book = $excel->Workbooks->open($workbook1);
    my $sheet1= $Book->Worksheets(1);
    
while (my $a_ref = $stf->fetch()) {
    my ($zeile_alt, $znr, $ind, $dat, $zng_aus_Mon, $ind_aus_Mon) = @$a_ref;   
    
    printf "Zeile %04d Zeichnung %s %s PDF: %02d  Eintrag in Monitoring: %02d  %02d\n", $zeile_alt, $znr, $ind, $dat, $zng_aus_Mon, $ind_aus_Mon;
    
    if (($dat == 1) and ($zng_aus_Mon == 1)) {
        
    }
    
    my ($status, $text, $index_text, $color)
        = (($dat) and ($zng_aus_Mon) and ($ind == $ind_aus_Mon))
        ? ('ok', q{}, q{}, 0)
        
        : (($dat) and ($zng_aus_Mon) and ($ind < $ind_aus_Mon))
        ? ('ok', 'pdf vorhanden', "Neuerer Index $ind_aus_Mon", 43)
        
        : (($dat == 0) and ($zng_aus_Mon) and ($ind > $ind_aus_Mon))
        ? ('fehler', 'pdf nicht vorhanden', "Älterer Index $ind_aus_Mon", 27)
        
        : (($dat == 0) and ($zng_aus_Mon) and ($ind  == $ind_aus_Mon))
        ? ('fehler', 'pdf nicht vorhanden', 'Zeichnung in Monitoring aufgeführt', 46)
        
        : (($dat == 0) and ($zng_aus_Mon) and ($ind < $ind_aus_Mon))
        ? ('fehler', 'pdf nicht vorhanden', "Zeichnung mit Index $ind_aus_Mon in Monitoring aufgeführt", 22)
        
        : (($dat == 0) and ($zng_aus_Mon == 0))
        ? ('fehler', 'pdf nicht vorhanden', 'Zeichnung nicht in Monitoring', 3)
        
        : ('ERROR', 'keine der Bedingung trift zu', 'warum ', 41);
        
    my $zeile = $zeile_alt + 1;
    $sheet1->Cells($zeile,5)->{Value} = $status;
    $sheet1->Cells($zeile,6)->{Value} = $text;
    $sheet1->Cells($zeile,7)->{Value} = $index_text;        
    $sheet1->Cells($zeile,1)->Interior->{ColorIndex} = $color if $color;
    
}
    
    
    
$Book->Save;
print "Fertig";
$excel    -> Quit;
