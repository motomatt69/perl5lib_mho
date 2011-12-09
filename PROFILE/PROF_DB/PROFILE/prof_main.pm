package PROFILE::PROF_DB::PROFILE::prof_main;
use strict;
use warnings;

use base 'PROFILE::PROF_DB::PROFILE::Base';

__PACKAGE__->table('prof_main');

__PACKAGE__->columns(All =>
                     qw/
                     row_name_id
                     row_name
                     dstv_name
                     row_beschrieb1
                     row_beschrieb2
                     row_din
                     row_typ_id
                     formula_typ_id
                     row_tab_dat
                     /);

__PACKAGE__->columns(Essential =>
                     qw/
                     row_name_id
                     row_name
                     dstv_name
                     row_beschrieb1
                     row_beschrieb2
                     row_din
                     row_typ_id
                     formula_typ_id
                     row_tab_dat
                     /);

1;