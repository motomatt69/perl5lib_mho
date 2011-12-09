package BANK::DB::STRUCT::empf_abse;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('empf_abse');

my @columns = qw(ID empf_abse);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;