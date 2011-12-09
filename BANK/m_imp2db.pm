package BANK::imp2db;
use strict;
use File::Slurp;
use File::Spec;

use BANK::DB::STRUCT;


my @dirs = ('c:', 'Programme', 'StarMoney 6.0', 'export');
#my $file = '1000527692_20100117.csv';
#my $file = '267393700_20100117.csv';
#my $file = '11463715_20100105.csv';
#my $file = '11530208_20100116.csv';
my $path = File::Spec->catfile( @dirs, $file );


my $new_ref = select_new_ones($path);
$new_ref    = clean_records($new_ref);
$new_ref    = check_unterkat($new_ref);

insert_into_DB($new_ref);
my $dummy;


sub insert_into_DB{
    my ($new_ref) = @_;

    my @newones = @$new_ref;
    
    my $cdbh = BANK::DB::STRUCT->new();
    
    for my  $newone (@newones){
        my ($empf_abse) = $cdbh->empf_abse->find_or_create({empf_abse => $newone->[9]});
        $newone->[9] = $empf_abse->ID();

        my ($buchung) = $cdbh->buchungen->find_or_create({  ID          => $newone->[0], 
                                                            konten_ID   => $newone->[1],
                                                            datum       => $newone->[2],
                                                            betrag      => $newone->[3],
                                                            saldo       => $newone->[4],
                                                            verzweck1   => $newone->[5],
                                                            verzweck2   => $newone->[6],
                                                            verzweck3   => $newone->[7],
                                                            verzweck4   => $newone->[8],
                                                            empf_abse_ID=> $newone->[9],
                                                            unterkat_ID => $newone->[10],
                                                            });
    }

}


sub check_unterkat{
    my ($new_ref) = @_;
    
    my @newones = @$new_ref;
    
    my $cdbh = BANK::DB::STRUCT->new();
    my $dbh = $cdbh->dbh();
    
    my $sth = $dbh->prepare( qq(SELECT  regex, unterkat_ID
                                FROM    regex2unterkat
                                ));
                                          
    $sth->execute();
    
    my (@regexs);
    while (my @rec = $sth->fetchrow_array()){
        push @regexs, [$rec[0], $rec[1]];
    }
    
    
    for my $newone (@newones){
        my $cnt;
        for my $regex (@regexs){
            if ($newone->[9] =~ m/$regex->[0]/){
                $cnt = 1;
                $newone->[10] = $regex->[1]
            }
            elsif($newone->[5] =~ m/$regex->[0]/){
                $cnt = 2;
                $newone->[10] = $regex->[1]
            }
            elsif($newone->[6] =~ m/$regex->[0]/){
                $cnt = 3;
                $newone->[10] = $regex->[1]
            }
        }
        if ($cnt){
            #if ($cnt == 1) {print "empf abse Treffer: $newone->[9]\n"};
            #if ($cnt == 2) {print "verzeck1  Treffer: $newone->[5]\n"};
            #if ($cnt == 3) {print "verzweck2 Treffer: $newone->[6]\n"};
        }
        else{
            $newone->[10] = 121; #121 = OHNE UNTERKAT
            print "Kein Treffer $newone->[0], $newone->[9], $newone->[5], $newone->[6], $newone->[3] \n";
        }
        
    }
    
    return \@newones
}

sub clean_records{
    my ($new_ref) = @_;
    
    my @newones = @$new_ref;
    
    
    for my $newone (@newones){
        for my $val (@$newone){
            if ($val =~ m/^".*"/) {
                ($val) = $val =~ m/^"(.*)"/
            }
        }
        my $date = $newone->[3];
        my ($dd, $mm, $yyyy) = $date =~ m/(\d+)\.(\d+)\.(\d+)/;
        $dd = ($dd <= 9) ? '0'.$dd : $dd;
        $mm = ($mm <= 9) ? '0'.$mm : $mm;
        $newone->[3] = $yyyy.'-'.$mm.'-'.$dd;
        
        my $betrag = $newone->[0];
        $betrag =~ s/,/\./g;
        $newone->[0] = $betrag;
        
        my $saldo = $newone->[14];
        $saldo =~ s/,/\./g;
        $newone->[14] = $saldo;
        
    }
    
    @newones = map {[$_->[9],   #id         0
                     $_->[41],  #konten_id  1
                     $_->[3],   #datum      2
                     $_->[0],   #betrag     3
                     $_->[14],  #saldo      4
                     $_->[26],  #verzweck1  5
                     $_->[27],  #verzweck2  6
                     $_->[28],  #verzweck3  7
                     $_->[29],  #verzweck4  8
                     $_->[6],   #empf_abse  9
                     $_->[25],  #unterkat   10
                     ]} @newones;
            
    return \@newones;
}

sub select_new_ones{
    
    my $cdbh = BANK::DB::STRUCT->new();
    my $dbh = $cdbh->dbh();
    
    my ($kto_nr) = $path =~ m/\\(\d+)_/;
    my ($kto) = $cdbh->konten->search({kto_nr => $kto_nr});
    if (!$kto) {die "Konto nicht angelegt!"};
    my $kto_ID = $kto->id();
    
    my $sth = $dbh->prepare( qq(SELECT  ID
                                FROM    buchungen
                                WHERE   konten_ID = ?));
                                          
    $sth->execute($kto_ID);
    
    my (@vorh);
    while (my @rec = $sth->fetchrow_array()){
        push @vorh, $rec[0];
    }
    my $cntvorh = @vorh;
    
    my @implines = read_file($path);
    if ($implines[0] =~ m/Betrag/){
        shift @implines
    }
    my $cntimpdat = @implines;
    
    my @newones;
    for my $impline (@implines){
        my @imp = split ';', $impline;
        my $id = $imp[9];
        if (!grep{$_ == $imp[9]} @vorh){
            push @newones, [@imp, $kto_ID]
        }        
    }
    my $cntnewones = @newones;
    
    print "gesamt: $cntimpdat\n";
    print "vorh  : $cntvorh\n";
    print "neu   : $cntnewones\n";
    
    return \@newones;
}

1;

