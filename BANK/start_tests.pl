#!/usr/bin/perl -w
use strict;
use BANK::DB::STRUCT;

my $dbh = BANK::DB::STRUCT->new();

my ($konten) = $dbh->konten->search({kto_bez => 'mho giro comdirect'});

my $name = $konten->namen_ID->vorname;
my $bank = $konten->banken_ID->bank_name;

my $dummy;

