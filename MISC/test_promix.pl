use strict;
use warnings;

use DBI;

my $dbh = DBI->connect('dbi:ODBC:odbcprof8', 'prof4');
my $auf_id = $dbh->selectrow_array(qq(
    SELECT auf_id
    FROM auftrag
    WHERE auf_nr = '090408'
    ));

my @zngs = _only_last_revs($auf_id);

my %wz;
for my $z (@zngs){
    print "#########################################################\n";
    print $z->[0],"\n";
    my @zng_teile = _get_teile2zeichnung($auf_id, $z->[31]);
    my @zng_hts = grep{$_->[5] == 0} @zng_teile;
    my ($wz_anz, $wz_gew);
    for my $ht (@zng_hts){
        my $ht_gew;
        print "_____________________________________\n";
        print $ht->[7],"\n";
        my @abts = grep{$_->[6] == $ht->[0]} @zng_teile;
        for my $abt (@abts){
            print $abt->[10],'|',$abt->[13],'|',$abt->[18],"\n";
            
            
            $ht_gew += ( $abt->[18]);
            print "$ht_gew\n";
        }
        $ht_gew += $ht->[18] / $ht->[13];
        
         print "Gewicht $ht_gew\n";
        
        $wz{$z->[0]}->{poss}{$ht->[7]} = [$ht->[13], $ht_gew, $z->[0]];
        $wz_anz += $ht->[13];
        $wz_gew += $ht_gew;
    }
   
   
    my $dummy;
}

for my $key (sort keys %wz){

    for my $key_poss (%{$wz{$key}->{poss}}){
        my $zng_anz += $wz{$key}->{poss}{$key_poss}->[0];
        my $zng_g += $wz{$key}->{poss}{$key_poss}->[1];
        my $gesg = $zng_anz * $zng_g;
        print "$key_poss:  $zng_anz * $zng_g = $gesg\n";
    }    
}



sub _only_last_revs{
    my ($auf_id) = @_;
    
    my $dbh = DBI->connect('dbi:ODBC:odbcprof8', 'prof4');
        
    my $sth = $dbh->prepare(qq(SELECT *
                        FROM zeichnung
                        WHERE zng_auf_id = $auf_id
                        AND zng_uauf_nr = 1
                        ORDER BY zng_nr, zng_aenind DESC
                        ));
    $sth->execute();
    my @all_zngs = @{$sth->fetchall_arrayref()};
    
    my (%tmp, @zngs); 
    for my $z (@all_zngs){
        next if ($tmp{$z->[0]});
        push @zngs, $z;
        $tmp{$z->[0]} = 1;
    }

    return @zngs;
}

sub _get_teile2zeichnung{
    my ($auf_id, $zng_id) = @_;
    
    my $dbh = DBI->connect('dbi:ODBC:odbcprof8', 'prof4');
        
    my $sth = $dbh->prepare(qq(SELECT *
                            FROM aufpos
                            WHERE aup_auf_id = $auf_id
                            AND aup_zng_id = $zng_id
                            ));
    $sth->execute();
    my @teile = @{$sth->fetchall_arrayref};

    return @teile
}
    



