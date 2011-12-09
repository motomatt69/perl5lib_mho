#!/usr/bin/perl -w
use strict;
use File::Slurp;
use File::Spec;
use db_profile::db_profile;

my @dir = qw/C: dummy RStabProfile/;
my $file = '1_2HEA_VARS.txt';


my $path = File::Spec->catfile( @dir, $file );
my @lines = read_file( $path) ;

my @tab;
foreach my $line (@lines) {
    my @data = split /;/,$line;
    push @tab, \@data;
}
    
my $dummy;

#Tabelle anlegen mit ID
#Datenbank verbinden
my $dbh = DBI->connect('DBI:mysql:database=profile;host=localhost','root','');
print "verbunden\n";

my $sql = <<'SQL';
    ALTER TABLE 1_2hea
    FROM auf_data
SQL
    my $sth = $dbh->prepare($sql);
#   Abfrag ausführen
    $sth->execute;
    while (my @val = $sth->fetchrow_array()){
    print $val[0],"\n";
    }   
    $sth->finish;
1;