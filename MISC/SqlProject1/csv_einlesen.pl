#!/usr/bin/perl -w
use strict;
use File::Slurp;


my $dat_hash_ref;
einlesen();
#print $dat_hash_ref;
sqlschreiben();

sub sqlschreiben {
    use daten1;
    my $dbh = Daten1::connect();
    print "Verbunden\n";
    
    for my $key (keys %$dat_hash_ref) {
            #print "$key  $$dat_hash_ref{$key}\n";
            my $datsaref = $$dat_hash_ref{$key};#Datensatzhash dereferenzierne
            #print "$datsaref\n";
            my @datsa = @$datsaref;#Datensätze dereferenzieren
            #print @datsa;
    
    my $sqleingabe=$dbh->prepare("INSERT IGNORE INTO daten (anz,bez,lae,bre,hoe,gew,ts,hp,bwku,zchnku) VALUES
                           ('".$datsa[0]
                           ."','".$datsa[1]
                           ."','".$datsa[2]
                           ."','".$datsa[3]
                           ."','".$datsa[4]
                           ."','".$datsa[5]
                           ."','".$datsa[6]
                           ."','".$datsa[7]
                           ."','".$datsa[8]
                           ."','".$datsa[9]
                           ."');");
    $sqleingabe->execute;
    $sqleingabe->finish;
    }
    
    $dbh->disconnect();
    print "Verbindung geschlossen\n";
}


sub einlesen {
    my $file ='c:\dummy\daten.txt';
    my @lines =  read_file( $file );
    my (%dat_hash);
    foreach $_ (@lines) {
        my @datensatz = split (';',$_);
        pop @datensatz;
        $dat_hash{$datensatz[7]}=\@datensatz;#Datensätze referenzieren
        #print $_;
        $dat_hash_ref = \%dat_hash#Datensatzhash referenzieren
    }
return $dat_hash_ref;    
}


    



    