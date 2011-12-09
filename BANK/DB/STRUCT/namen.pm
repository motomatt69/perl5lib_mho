package BANK::DB::STRUCT::namen;
use strict;
use warnings;
use base 'BANK::DB::STRUCT::Base';

__PACKAGE__->table('namen');

my @columns = qw(ID vorname nachname);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

#__PACKAGE__->has_a(row_name_id => 'PROFILE::PROF_DB::PROFILE::prof_main');
1;