package BANK::DB::STRUCT::konten;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('konten');

my @columns = qw(ID kto_bez kto_nr namen_ID banken_ID);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

__PACKAGE__->has_a(namen_id => 'BANK::DB::STRUCT::namen');
__PACKAGE__->has_a(banken_id => 'BANK::DB::STRUCT::banken');
1;