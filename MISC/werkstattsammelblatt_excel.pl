#!/usr/bin/perl -w
use strict;
use DB::SWD;
use DB::SWD::AppInfo qw(initAppInfo :set);
use DB::Archiv;
use File::RGlob;
use File::Spec;
use File::Copy;
use DB::SWD::Exchange::File;

use PPEEMS::DB::PPEEMS;

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
use PPEEMS::HELPERS::extract_pdf;

my $sdb = DB::SWD->new(1);
my $edb = PPEEMS::DB::PPEEMS->new();

my $path = File::Spec->catdir(
    '//server-bocad',
    'Auftraege',
    '090477_eemshaven_zeichnungen',
    'werkstattzeichnungen',
    '900005'
);

my $rg = File::RGlob->new(path => $path);
my $ex  = PPEEMS::HELPERS::extract_pdf->new();

initAppInfo($sdb->dbh);
setAppInfoUser('Kaupp');
setAppInfoOrder('090477');

package PPEEMS::Uebernahme::MHO;
use DB::SWD::AppInfo qw(:set);
use version; our $VERSION = qv('0.0.0');

setAppInfoApplication();

package main;

#my $sdb = DB::SWD->new(1);

my ($versandart) = $sdb->versandart->search(
    name    => 'WERKSTATTSAMMELBLATT'
);
my ($projekt) = $sdb->projekt->search(
    nummer => '090477'
);

my ($zngtyp) = $sdb->zngtyp->search(
    typ => 'Werkstattsammelblatt'
);

my ($zngdateityp) = $sdb->zngdateityp->search(
    typ => 'PDF'
);

$rg->scan();
for my $file ($rg->list_files()) {
    $ex->pdf_p($file);
    $ex->extract();
}

#read_file(undef, $file);

my %pdf = $ex->get_pdfs_data();
my %aznr = ();
for my $pdf (sort keys %pdf) {
    my $pdfref = $pdf{$pdf};
    my $bookref = $pdfref->{Bookmark};
    my $file    = $pdfref->{file};
    
    my $title   = $pdfref->{Title} || $pdf;
    my $crdate  = $pdfref->{CreationDate};
    if (!$crdate) {
        $crdate = (stat $file)[10];
        my ($s, $m, $h, $dd, $mm, $yy) = localtime $crdate;
        $crdate = sprintf
            '%04d-%02d-%02d %02d:%02d:%02d',
            $yy + 1900, $mm + 1, $dd, $h, $m, $s;
    }
    else {
        $crdate =~ s/(\d{2}).(\d{2}).(\d{4})/$3-$2-$1 00:00:00/;
    }
    print "$file\n";
    
    my ($block, $ws_nr, $ws_rev) =
        $pdf =~ m/\A (\d) - (\d{6}-\d{2}) _ (\d{2}) .pdf \z/xms;
        
    my @blattnr = sort { $a <=> $b} keys %$bookref;
    for my $blattnr (@blattnr) {
        my $blattref = $bookref->{$blattnr};
        my (@htzngnr) = grep { m/^hp/ } keys %$blattref;
        
        for my $htzngnr (@htzngnr) {
            print "\t$htzngnr $blattnr $crdate\n";
            
            my ($tsnr, $htnr, $blnr, $rev) =
                $htzngnr =~ m/\A hp (\d{6}) 0 (\d{5}) _ (\d{2}) _ (\d{2}) \z/xms;
            print "\t\t $tsnr $htnr $blnr $rev \n";
            my ($bgnr, $cube) = $tsnr =~ m/\A (\d{3}) (\d{3}) \z/xms;
            
            my %args = (
                tsnummer    => $tsnr,
                htnr        => $htnr,
                blattnr     => $blnr,
                revnr       => $rev,
                baugruppe   => $bgnr,
                cube        => $cube,
                block       => $block,
                ws_nummer   => $ws_nr,
                ws_revnr    => $ws_rev,
                ws_blatt    => $blattnr,
                basename    => $pdf,
                datum       => $crdate,
            );
            
            eintragen(\%args);
        }
    }
}
my $dummy;

for my $nr (sort keys %aznr) {
    print "$nr : $aznr{$nr} \n";
}
sub eintragen {
    my ($args) = shift;
    
    my @v_aposzng2htzngbl = $sdb->v_aposzng2htzngbl->search(
        projekt     => $projekt->nummer(),
        block       => $args->{block},
        baugruppe   => $args->{baugruppe},
        tsnummer    => $args->{tsnummer},
        htnr        => $args->{htnr},
        blattnr     => $args->{blattnr},
        revnr       => $args->{revnr},
    );
    
    my $anz = @v_aposzng2htzngbl;
    print "\t\t\t$anz\n";
    
    my $ws_nr  = $args->{block} . '-' . $args->{ws_nummer};
    my $ws_bls = $args->{ws_blatt};
    my $ws_rv  = $args->{ws_revnr};
    
    for my $v_aposzng2htzngbl (@v_aposzng2htzngbl) {
        print "\t\t\t\t", $v_aposzng2htzngbl->nummer(), "\n";
        $aznr{$v_aposzng2htzngbl->nummer()}++;
        my $aposzng_rev = $v_aposzng2htzngbl->aposzng_rev();
        eval {
            my $wszng = $sdb->wszng->find_or_create({
                projekt => $projekt->id(),
                nummer  => $ws_nr,
            });
            
            my $wszngbl = $sdb->wszngbl->find_or_create({
                wszng   => $wszng->id(),
                blattnr => $ws_bls,
            });
            
            my ($wszngbl_rev) = $sdb->wszngbl_rev->search(
                wszngbl => $wszngbl->id(),
                revnr   => $ws_rv,
            );
            
            my $zngrev;
            if (!$wszngbl_rev) {
                $zngrev = $sdb->zngrev->insert({
                    zngtyp => $zngtyp->id(),
                    revnr  => $ws_rv,
                });
                
                $wszngbl_rev = $sdb->wszngbl_rev->find_or_create({
                    wszngbl => $wszngbl->id(),
                    zngrev  => $zngrev->id(),
                    revnr   => $ws_rv,
                });
            }
            else {
                $zngrev = $wszngbl_rev->zngrev();
            }
            
            my $empfaenger = $sdb->empfaenger->find_or_create({
                eintrag => $wszngbl_rev->id(),
            });
            
            my $versand = $sdb->versand->find_or_create({
                eintrag => $aposzng_rev->id(),
                empfaenger => $empfaenger->id(),
                versandart => $versandart->id(),
            });
            
            my $datd = File::Spec->catdir(
                '090477',
                'werkzng',
                'pdf'
            );
            
            my $datn = File::Spec->catpath(
                '//server-doku/auftrag',
                $datd,
                $args->{basename}
            );
            
            $datn =~ tr/\//\\/;
            
            my $datei = $sdb->datei->find_or_create({
                pfad => $datn
            });
            
            my $zngdatei = $sdb->zngdatei->find_or_create({
                datei   => $datei->id(),
                zngrev  => $zngrev->id(),
                zngdateityp => $zngdateityp->id(),
            });
            $versand->datum($args->{datum});
            $versand->update();
            $sdb->commit();
        };
        
        if ($@) {
            my $error = $@;
            eval { $sdb->rollback(); };
            print "$error\n";
        }
        
    }
}

