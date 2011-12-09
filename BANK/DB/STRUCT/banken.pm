package BANK::DB::STRUCT::banken;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('banken');

my @columns = qw(ID bank_name bank_blz);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);


1;