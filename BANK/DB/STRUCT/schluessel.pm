package BANK::DB::STRUCT::schluessel;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('schluessel');

my @columns = qw(ID textschluessel schluessel);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;