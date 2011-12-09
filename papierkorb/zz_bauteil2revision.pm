package PPEEMS::DB::PPEEMS::zz_bauteil2revision;
use strict;
use warnings;

use base 'PPEEMS::DB::PPEEMS::Base';

__PACKAGE__->table('zz_bauteil2revision');

my @columns = qw(bauteil2revision
                 bauteil
                 revision
                 b3dpos
                 );

__PACKAGE__->columns(All        => @columns);
__PACKAGE__->columns(Essential  => @columns);




1;
