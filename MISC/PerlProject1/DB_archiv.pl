#!/usr/bin/perl -w
use strict;
use DB::Archiv;

my $auftragsnummer= '080335';
my $auf = DB::Archiv->get_auftrag($auftragsnummer);
print $auf;

