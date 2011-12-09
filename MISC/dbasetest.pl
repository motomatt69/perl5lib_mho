#!/usr/bin/perl -w
use strict;
use DBI;
use File::Copy;

my $v = "//cad-7/auftrag/";
my @dirs = qw(100467_meyerwerft_halle11 lists st_prm);

my $p = File::Spec->catdir($v, @dirs);


my $dbh = DBI->connect("DBI:XBase:$p") or die $DBI::errstr;

#Auftragsdaten
my @auf = $dbh->selectrow_array(qq( SELECT  AUFTRAG, BESTELLER, OBJEKT,
                                            DATUM, UHRZEIT
                                    FROM    auftrag
                            )) or die $DBI::errstr;

my %dbase = ('adat' => {'anr' => $auf[0],
                        'best' => $auf[1],
                        'obj' => $auf[2],
                        'date' => $auf[3],
                        'time' => $auf[4]
                        },
            );

#Teilsysteme
my $sth = $dbh->prepare(qq(SELECT   ZNR
                           FROM    zeichng
                        )) or die $DBI::errstr;
$sth->execute() or die $DBI::errstr;
my $rnr = 1;
while (my $rec = $sth->fetchrow_arrayref()){
    $dbase{tsnrs}->{$rec->[0]}{recnr} = $rnr;
    $rnr++
}
$sth->finish();

%dbase = _assemblies2phase($dbh, %dbase);
%dbase = _members2assemblies($dbh, %dbase);
#Hauptpositionen zu Teilsystem

sub _assemblies2phase{
    my ($dbh, $p, %dbase) = @_;
    
    my $znr_zpos = _read_idx_table($p, 'znr_zpos');
    
    $sth = $dbh->prepare(qq(SELECT  PNR, BEZEICHNG, BENENNUNG,
                                    LAENGE, BREITE, HOEHE,
                                    FLAECHE, GEWICHT, IDNR
                            FROM    zpos
                        )) or die $DBI::errstr;
    $sth->execute() or die $DBI::errstr;
    my %zpos;
    my $recnr = 1;
    while (my $rec = $sth->fetchrow_arrayref()){
        $zpos{$recnr} = [$rec->[0], $rec->[1], $rec->[2],
                         $rec->[3], $rec->[4], $rec->[5],
                         $rec->[6], $rec->[7], $rec->[8]
                         ];
        $recnr++;
    }
    $sth->finish();
    
    my %tsnrs = %{$dbase{tsnrs}};
    for my $key (keys %tsnrs){
        my $tsrecnr = $tsnrs{$key}->{recnr};
        my @recs = grep{$_->[0] == $tsrecnr} @{$znr_zpos};
        my $cnt = 0;
        for my $rec (@recs){
            my $hpos = $zpos{$rec->[1]};
            
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{recnr} = $rec->[1];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{anz}   = $rec->[2];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{posnr} = $hpos->[0];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{bez}   = $hpos->[1];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{ben}   = $hpos->[2];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{lae}   = $hpos->[3];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{bre}   = $hpos->[4];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{hoe}   = $hpos->[5];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{flae}  = $hpos->[6];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{gew}   = $hpos->[7];
            $dbase{tsnrs}->{$key}{hposs}[$cnt]{idnr}  = $hpos->[8];
            $cnt++;
        }
    }
    
    
    $dbh->disconnect();
    
    
    my $dummy;
  #  unlink $tp;
    
 
    
    return %dbase;
}

sub _members2assemblies{
    my ($dbh, %dbase) = @_;

    

}

sub _read_idx_table{
    my ($dbh, $p, $tab) = @_;
    
    my $sp = File::Spec->catfile($p, $tab.'.idx');
    my $tp = File::Spec->catfile($p, $tab.'.dbf');
    copy($sp, $tp);
    
    my $sth = $dbh->prepare(qq(SELECT  RECTOP, RECDOWN, ANZAHL
                            FROM    $tab
                        )) or die $DBI::errstr;
    $sth->execute() or die $DBI::errstr;
    
    my $data = $sth->fetchall_arrayref();
    
    return ($tp, $data);
}
    
    
    
    
    