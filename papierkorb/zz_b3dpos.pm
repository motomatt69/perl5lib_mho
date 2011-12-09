package PPEEMS::DB::PPEEMS::zz_b3dpos;
use strict;
use warnings;

use base 'PPEEMS::DB::PPEEMS::Base';

__PACKAGE__->table('zz_b3dpos');

my @columns = qw(b3dpos
                 posnr
                 anz
                 bez
                 ts
                 teilzng
                 );

__PACKAGE__->columns(All        => @columns);
__PACKAGE__->columns(Essential  => @columns);

1;
