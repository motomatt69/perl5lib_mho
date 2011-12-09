#!/usr/bin/perl -w
use strict;

my %table;
my $i = 'Zeile';
@table{"$i eins", "$i zwei", "$i drei"} = (1,2,3);

map { print $_, ' : ', $table{$_}, "\n"; } keys %table;
