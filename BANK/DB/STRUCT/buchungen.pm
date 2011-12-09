package BANK::DB::STRUCT::buchungen;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('buchungen');

my @columns = qw(ID konten_ID datum betrag saldo
                 verzweck1 verzweck2 verzweck3 verzweck4  
                 empf_abse_ID unterkat_ID);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

__PACKAGE__->has_a(konten_id => 'BANK::DB::STRUCT::konten');
__PACKAGE__->has_a(unterkat_id => 'BANK::DB::STRUCT::unterkat');
__PACKAGE__->has_a(empf_abse_id => 'BANK::DB::STRUCT::empf_abse');

1;