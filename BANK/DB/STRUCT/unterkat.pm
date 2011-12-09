package BANK::DB::STRUCT::unterkat;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('unterkat');

my @columns = qw(ID unterkat kategorie_ID);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;