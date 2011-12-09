#!/usr/bin/perl -w
use strict;

use Tk;
use Tk::XPMs qw(openfolder_xpm);
use Tk::TableMatrix;
use Tk::Grid::Utils qw(gridConfigure gridPara);
use Spreadsheet::ParseExcel::SaveParser;
use Spreadsheet::ParseExcel::SaveParser::Workbook;

my $oExcel;
my $oBook;
my $oSheet;

my $mw = MainWindow->new();
$mw->geometry('800x640');

gridConfigure($mw, {-rows       => [32, '192v', 32],
                    -cols       => [800],});

my $f1 = $mw->Frame()->grid(gridPara 0,0);
my $f2 = $mw->Frame()->grid(gridPara 1,0);
my $f3 = $mw->Frame()->grid(gridPara 2,0);

gridConfigure($f1, {-rows       => [32],
                    -cols       => [96, '192v', 32],});
gridConfigure($f2, {-rows       => ['32v'],
                    -cols       => ['32v'],});
gridConfigure($f3, {-rows       => [32],
                    -cols       => ['32v', '32v', '32v'],});

$f1->Label(-text => 'Vorlage',
           )->grid(gridPara 0,0);

my $e =$f1->Entry(
           )->grid(gridPara 0,1);

$f1->Button(-image => $f1->Pixmap(-data => openfolder_xpm()),
            -command => sub { vorlage_waehlen() },
           )->grid(gridPara 0,2);

my $tm = $f2->TableMatrix(-rows => 15,
                 -cols => 12,
                 -cache => 'on',
                )->grid(gridPara 0,0);

$f3->Button(-text => 'lesen',
            -command => sub { lesen() },
           )->grid(gridPara 0,0);
$f3->Button(-text => 'schreiben',
            -command => sub { schreiben() },
           )->grid(gridPara 0,1);
$f3->Button(-text => 'beenden',
            -command => sub { exit },
           )->grid(gridPara 0,2);

MainLoop;


sub vorlage_waehlen {
    my $file = $f1->getOpenFile();
    $file ||= $e->get();
    $e->delete('0','end');
    $e->insert('end', $file);
}

sub lesen {
    my $file = $e->get();
    $oExcel = Spreadsheet::ParseExcel::SaveParser->new();
    $oBook = $oExcel->Parse($file);
    $oSheet = $oBook->{Worksheet}[0];
    
}

sub schreiben {
    my $file = $f3->getSaveFile();
    
    for my $row (0 .. 14) {
        my $re = $row+12;
        for my $col (0 .. 11) {
            my $val = $tm->get("$row,$col");
            my $oCell = $oSheet->{Cells}[$re][$col];
            $oBook->AddCell(0, $re, $col, $val, $oCell);
        }
    }
    $oExcel->SaveAs($oBook, $file);
}