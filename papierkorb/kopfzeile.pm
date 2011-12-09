package PROFILE::kopfzeile;
use strict;
use DBI;


sub Kopfzeile_vorbereiten {
    my ($class, $tab_name, @tab) = @_;
    
    my $kozei_ref = $tab[0];
    my @kozei = @$kozei_ref;

    shift @kozei; #Hea weg
    pop @kozei; #newline weg
    
    my @kozei_checked;
    
    foreach my $dat (@kozei) {
        if ($dat) {
            $dat =~ s/ //g;         #keine Leerzeichen
            $dat =~ s/-/_/g;        #keine Bindestriche
            $dat =~ s/,/_/g;        #keine Kommas
            $dat =~ s/iy/i_y/;      #Groß und Kleinschreibung nicht unterschieden
            $dat =~ s/iz/i_z/;      #Groß und Kleinschreibung nicht unterschieden    
            push (@kozei_checked, $dat)
        }
    }
    return @kozei_checked;
}

sub Kopfzeile_anlegen {
    my ($class, $tab_name, @tab) = @_;
    
    my @kozei = $class->Kopfzeile_vorbereiten ($tab_name, @tab);
    
    my $dbh = PROFILE::DB::profile->get_db_handle();
    
    foreach my $dat (@kozei) {
        my $sql1 = 'ALTER TABLE '.$tab_name.' ADD '.$dat.' FLOAT';
        my $sth = $dbh->prepare($sql1);
        #   Abfrag ausführen
        $sth->execute;
        $sth->finish;
    }
    
    return @kozei;
}        

1;