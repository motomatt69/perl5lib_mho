#!/usr/bin/perl -w
use strict;
use DBI;
use DB::Archiv qw(get_auftrag);
my $dbh = DB::Archiv->get_db_handle();

#Zeugs aus archiv holen;
my $anr = "090171";
my $tx_zdat=[];

$tx_zdat = zeichnungsdaten ($anr,$tx_zdat);

#foreach (@$tx_zdat) {
#    print "$_->[0] $_->[1] \n"
#}
                     
    #print "v_main Zeichnungsdaten in: $rows Reihen\n";
    #foreach my $i (1..$rows) {
    #    print "$i: ",$tx_zdat->{"$i,0"},"\t\t";
     #   print " ",$tx_zdat->{"$i,1"},"\n";
        #print "$i: ",$tx_zdat->{"$i,2"},"\t\t";
        #print "$i: ",$tx_zdat->{"$i,3"},"\n";
    #}

printf "%2d:%2d:%2d\n", (localtime)[2,1,0];
#In anydata Tabelle schreiben
my $anydbh = DBI -> connect('dbi:AnyData(RaiseError=>1):');

#$anydbh->do("CREATE TABLE test (typ TEXT,zng_nr INT)");
#my $sth = $anydbh->prepare("INSERT INTO test VALUES (?, ?)");
#    foreach (@$tx_zdat) {
#print "$_->[0] $_->[1] \n";
#$anydbh->do(qq/INSERT INTO test VALUES ('$_->[0]','$_->[1]')/);
#    $sth->execute(@{$_});
#    }
#    $sth->finish();
unshift @$tx_zdat, ['typ', 'zng_nr'];
$anydbh->func('test', 'ARRAY', $tx_zdat, 'ad_import');

printf "%2d:%2d:%2d\n", (localtime)[2,1,0];

#print
$anydbh->func ('test', 'HTMLtable','c:\dummy\test.htm', 'ad_export');
printf "%2d:%2d:%2d\n", (localtime)[2,1,0];

#Zeichnungsdaten abfragen
sub zeichnungsdaten {
    my($anr,$tx_zdat)=@_;
# Abfrage vorbereiten
my $sql = <<'SQL';
                    SELECT  zng_data_typ, zng_data_znr
                    FROM zng_data
                    WHERE zng_data_anr = ?
SQL

#my $sql = <<'SQL';
#                    SELECT  zng_data_typ,      zng_data_znr,    zng_data_blatt,    zng_data_index, zng_data_beschrieb, zng_data_index_text, 
#                            zng_data_massstab, zng_data_format, zng_data_Anstrich, zng_data_datum, zng_data_k_name,    zng_data_id
#                    FROM zng_data
#                    WHERE zng_data_anr = ?
#SQL
    my $sth = $dbh->prepare($sql);
                                
#Abfrag ausführen
   $sth->execute($anr);

    my $r=0;
    #while (my @v = $sth->fetchrow_array()){
        
    #    $tx_zdat->[$r] = \@v;
        #$tx_zdat->{"$r,1"} = "$v[1]";
        #$tx_zdat->{"$r,2"} = "$v[2]";
        #$tx_zdat->{"$r,3"} = "$v[3]";
        #$tx_zdat->{"$r,4"} = "$v[4]";
        #$tx_zdat->{"$r,5"} = "$v[5]";
        #$tx_zdat->{"$r,6"} = "$v[6]";
        #$tx_zdat->{"$r,7"} = "$v[7]";
        #$tx_zdat->{"$r,8"} = "$v[8]";
        #$tx_zdat->{"$r,9"} = "$v[9]";
        #$tx_zdat->{"$r,10"} = "$v[10]";
        #$tx_zdat->{"$r,11"} = "$v[11]";

    #    $r++;
    #}
    
    $tx_zdat = $sth->fetchall_arrayref();
    $sth->finish;
 
    return $tx_zdat;
}


