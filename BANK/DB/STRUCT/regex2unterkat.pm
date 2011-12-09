package BANK::DB::STRUCT::regex2unterkat;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('regex2unterkat');

my @columns = qw(ID regex unterkat_ID);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

__PACKAGE__->has_a(ID => 'BANK::DB::STRUCT::unterkat');

1;