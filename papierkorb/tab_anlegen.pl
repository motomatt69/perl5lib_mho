#!/usr/bin/perl -w
use strict;
use File::Slurp;
use File::Spec;
use PROFILE::dat_tab;
use PROFILE::cross_sec_tab;
use PROFILE::DB::TAB::prof_main;
use DBI;

my @rootdir = qw(c: perl5lib profile RUBSTAHL-TAFELN);
my $readfile = 'UPE.csv';
$readfile =~ m!(\S+)\.csv!;
my $row_name = $1;

my $readpath = File::Spec->catfile (@rootdir, $readfile);
my @tab = csv_einlesen($readpath);

#Datentabelle erstellen
PROFILE::dat_tab->dat($row_name, $readpath, \@tab);

#Eigenschaftstabelle ergänzen
my $readfileFO = $row_name."_FO.csv";
my $readpathFO = File::Spec->catfile (@rootdir, $readfileFO);
my @Fotab = csv_einlesen($readpathFO);


PROFILE::cross_sec_tab->tab_fuellen($row_name, $readpath, \@tab, \@Fotab);


sub csv_einlesen {
    my ($readpath)=@_;

    my @lines = read_file ($readpath);
    my @tab;
    foreach my $line (@lines) {
        my @data = split /;/, $line;
        push @tab , \@data;
    }
    return @tab;
}


1;


