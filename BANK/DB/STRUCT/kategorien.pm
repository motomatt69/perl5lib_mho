package BANK::DB::STRUCT::kategorien;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('kategorien');

my @columns = qw(ID kategorie);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;