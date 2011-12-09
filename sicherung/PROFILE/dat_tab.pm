package PROFILE::dat_tab;
use strict;
use File::Slurp;
use PROFILE::DB::TAB::prof_main;
use PROFILE::kopfzeile;
use DBI;

sub dat {
    my ($class, $row_name, $readpath, $tab_ref) = @_;
    my $tab_name= lc("$row_name"."_dat");
    
    $class->dat_tab_anlegen($tab_name, $row_name);
    my @tab = @$tab_ref;
    my @kozei = PROFILE::kopfzeile->Kopfzeile_anlegen ($tab_name, @tab);
    $class->dat_tab_fuellen ($tab_name, \@kozei, \@tab, $row_name);
}



sub dat_tab_anlegen {
    my ($class, $tab_name, $row_name) = @_;
    
    my $dbh = PROFILE::DB::profile->get_db_handle();
       
    my $sql1 = 'CREATE TABLE `mho`.`'.$tab_name.'` (`ID` INT UNSIGNED AUTO_INCREMENT, `row_name_id` INT UNSIGNED, `'.$row_name.'` VARCHAR (20), PRIMARY KEY(`ID`), UNIQUE(`ID`))';
   
    my $sth = $dbh->prepare($sql1);
    #   Abfrag ausführen
    $sth->execute;
    $sth->finish;
}

       
sub row_name_id_aus_prof_main {
    my ($class, $row_name) = @_;
    
    my @tab1 = PROFILE::DB::TAB::prof_main->search_like(row_name => $row_name);
    my $row_name_id = $tab1[0]->{row_name_id};
    
    return $row_name_id;
}

sub dat_tab_fuellen {
    my ($class, $tab_name, $kozei_ref, $tab_ref, $row_name) = @_;
    
    my @kozei = @$kozei_ref;
    my @tab = @$tab_ref;
    unshift @kozei, $row_name;
    unshift @kozei, 'row_name_id';

    my $dbh = PROFILE::DB::profile->get_db_handle();
    my $ID = 1001;
    foreach my $row (@tab) {
        my @dat = @$row;
        my $row_name_id = $class->row_name_id_aus_prof_main ($row_name);
        unshift @dat, $row_name_id;
        pop @dat; #newline weg
        if ($dat[2] =~ m!\d+!) {
            my $sql = 'INSERT INTO '.$tab_name.' (ID)
                       VALUES ('.$ID.')';
            my $sth = $dbh->prepare($sql);
            $sth->execute;
            $sth->finish;
            
            my $i = 0;
            foreach my $col (@dat) {
                if (!$col) {next}
                $col =~ s/\.//g; #Tausendertrennzeichen raus
                $col =~ s/,/\./g; #Komma durch Punkt ersetzen
                $col =~ s/\s//g; #Whitespace weg
                           
                my $sql = 'UPDATE '.$tab_name.' SET  '.$kozei[$i].' = \''.$col.'\'
                          WHERE ID = '.$ID;
                my $sth = $dbh->prepare($sql);
                $sth->execute;
                $sth->finish;
                
                $i++;
            }
            $ID++;
            if ($ID == 1030) {
                print $ID."\n"};
        }
    }
}

1;


