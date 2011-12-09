package PROFILE::DB::TAB::row_typ_properties;
use strict;
use warnings;

use base 'PROFILE::DB::profile';

__PACKAGE__->table('row_typ_properties');

__PACKAGE__->columns(All =>
                     qw/
                     ID
                     formula_typ_id
                     cross_sec_val
                     unit
                     formula
                     /);

__PACKAGE__->columns(Essential =>
                     qw/
                     ID
                     formula_typ_id
                     cross_sec_val
                     unit
                     formula
                     /);

1;