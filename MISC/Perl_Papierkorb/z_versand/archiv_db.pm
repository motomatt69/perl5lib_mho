package z_versand::archiv_db;
use strict;
use DBI;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(aufabfrag aufdat zngabfrag zngzaehl );
our @EXPORT_OK= qw ($auftraegeref $aufakttxtref $zngdatref $counthashref);

#Archiv DB verbinden
sub connect {
    my $dbh = DBI->connect('DBI:mysql:database=auftrag;host=server-sql','archiv','');
}
#Alle Auftragsnummern holen

sub aufabfrag {
    my $dbh = &connect();#DBI->connect('DBI:mysql:database=auftrag;host=server-sql','archiv','');
    # Abfrage vorbereiten
    my $aufh1 = $dbh->prepare(qq/SELECT auf_data_anr FROM auf_data/);
    #Abfrag ausführen
    $aufh1->execute;
    my $count=0; my @auf;
    while (my @val = $aufh1->fetchrow_array()){
        $auf[$count]=$val[0];
        $count++;
    }   
    $aufh1->finish;
    $dbh->disconnect();
    @auf = sort {$b <=> $a} @auf;
    return my $auftraegeref=\@auf;
}

#Auftragdaten abfragen
sub aufdat {
    my ($aufakt) = @_;
    my $dbh = &connect();
    # Abfrage vorbereiten
    my $aufh1 = $dbh->prepare(qq/SELECT auf_data_ag, auf_data_arch, auf_data_bez, auf_data_projekt_leiter FROM auf_data WHERE auf_data_anr = ?/);
    #Abfrag ausführen
    $aufh1->execute($aufakt);
    my @val = $aufh1->fetchrow_array();
    my %aufakttxt = ('Auftrag' => $aufakt,
                     'Bauherr' => $val[0],
                     'Architekt'=> $val[1],
                     'Bauwerk' => $val[2],
                     'Projektleiter' => $val[3]);
    $aufh1->finish;
    $dbh->disconnect();
    return my $aufakttxtref=\%aufakttxt;
    #return $aufakttxtref;
}

#Zeichnungsdaten abfragen
sub zngabfrag {
    my ($aufakt)=@_;
    $aufakt=$1 if ($aufakt=~ m/(\d+);\d/); #Auftragsnummer von ListboxIndex trennen
    my $dbh = &connect();
    # Abfrage vorbereiten
    my $zngh1 = $dbh->prepare(qq/SELECT zng_data_znr, zng_data_blatt, zng_data_index, zng_data_beschrieb, zng_data_index_text, zng_data_typ,
                             zng_data_massstab, zng_data_format, zng_data_Anstrich, zng_data_datum, zng_data_k_name
                             FROM zng_data WHERE zng_data_anr = ?/);
    #Abfrag ausführen
    $zngh1->execute($aufakt);
    my %zngdat;
    while (my @val = $zngh1->fetchrow_array()){
        $zngdat{$val[0].";".$val[1].";".$val[2]}=\@val;
    }
    $zngh1->finish;
    $dbh->disconnect();
    return my $zngdatref=\%zngdat;
}



sub zngzaehl {
    my ($zngdatref)=@_;
    my $countzng=0;my $countblt=0;my $countind=0;
    my %count;
    for my $key (sort {$a cmp $b} keys %$zngdatref) {
        my @val = split ";", $key;
        if ($val[1] eq "01" && $val[2] eq "00") {$count{zng}++} #Zeichnungen zählen
        $count{blt}++;  #Blätter zählen (auch mit Index)
        if ($val[2] ne "00") {$count{ind}++} #Indexe zählen
    }
    return my $counthashref=\%count;
}
1;