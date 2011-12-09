package PPEEMS::DB::PPEEMS::zz_subdwgs;
use strict;
use warnings;

use base 'PPEEMS::DB::PPEEMS::Base';

__PACKAGE__->table('zz_subdwgs');

my @columns = qw(subdwg_id
                 nest_nr
                 filetype
                 dx0
                 dy0
                 pw
                 ph
                 dateiname
                 vol
                 dirs);

__PACKAGE__->columns(All        => @columns);
__PACKAGE__->columns(Essential  => @columns);




1;
