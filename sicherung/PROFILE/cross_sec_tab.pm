package PROFILE::cross_sec_tab;
use strict;
use PROFILE::DB::TAB::prof_main;
use PROFILE::DB::TAB::row_typ_properties;
use PROFILE::kopfzeile;


sub tab_fuellen {
    my ($class, $row_name, $readpath, $tab_ref, $FOtab_ref) = @_;
    my $tab_name= lc("$row_name"."_val");
    
    my @tab = @$tab_ref;
    my @kozei = PROFILE::kopfzeile->Kopfzeile_vorbereiten($tab_name, @tab);
    
    my @tab1 = PROFILE::DB::TAB::prof_main->search_like(row_name => $row_name);
    my $formula_typ_id = $tab1[0]->{formula_typ_id};    
    
    my $c_sec_unit_ref = $tab[1]; #Cross_section_unit
    my @c_sec_unit = @$c_sec_unit_ref;
    shift @c_sec_unit; #Erste Leerstelle weg
    pop @c_sec_unit; #newline weg
    
    #Formelbehandlung
    my $Formeln_ref = $FOtab_ref->[5];
    my @Formeln = @$Formeln_ref;
    shift @Formeln; #Reihenname weg
    pop @Formeln; #newline weg
    

    my $ i = 0;
    foreach my $Fo (@Formeln) {
        
        if ($Fo =~ m!(^\d+$|^\d+,\d+)$!) {   #Geometrische Eingaben 
            $Fo = '-';
            $i++;
            next
        }
        
        $Fo =~ s!ZS\((-\d+)\)!\$$kozei[$i+$1]!g; #Zellbezüge durch Variablen erstezen
        $Fo =~ s!([+\-*\/=])! $1 !g; #Leerstellen hinzufügen
        $Fo =~ s!WURZEL!sqrt!g;#Wurzel 3
        #$Fo =~ s!WURZEL\((.+\))!\($1\*\*0\.5!g;  #Wurzel zu Potenz
        $Fo =~ s!\^!\*\*!g;        #Potenzieren                          
        $Fo =~ s!ZS\((\d+)\)!\$$kozei[$1-2]!g; #Zellbezüge durch Variablen erstezen
        $Fo =~ s!=!!;
        print "$i  "."$kozei[$i]: ".$Fo."\n";
        $i++;
    }
    
    
    
    
    
    $i = 0;
    foreach my $row (@c_sec_unit) {
        
     #   print $row_typ_id.": ".$kozei[$i]."->".$row."  ".$Formeln[$i]."\n";
    my $eintrag =  PROFILE::DB::TAB::row_typ_properties->find_or_create({formula_typ_id => $formula_typ_id,
                                                                         cross_sec_val => $kozei[$i],
                                                                         unit => $row,
                                                                         formula => $Formeln[$i]});
        
        $i++;
    }
    
my $dummy;
}


#sub val_tab_anlegen {
#    my ($class, $tab_name) = @_;
#    
#    my $dbh = PROFILE::DB::profile->get_db_handle();
#       
#    my $sql1 = 'CREATE TABLE `mho`.'.$tab_name.' (`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
#                                                   `row_name_id` INT UNSIGNED,
#                                                   `value` VARCHAR (50),
#                                                   `unit` VARCHAR (50),
#                                                   `formula` VARCHAR (50),
#                                                   PRIMARY KEY(`ID`), UNIQUE(`ID`))';
#
#    my $sth = $dbh->prepare($sql1);
#    #   Abfrag ausführen
#    $sth->execute;
#    $sth->finish;
#}    

1;