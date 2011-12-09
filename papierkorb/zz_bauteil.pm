package PPEEMS::DB::PPEEMS::zz_bauteil;
use strict;
use warnings;

use base 'PPEEMS::DB::PPEEMS::Base';

__PACKAGE__->table('zz_bauteil');

my @columns = qw(bauteil
                 alstopos
                 );

__PACKAGE__->columns(All        => @columns);
__PACKAGE__->columns(Essential  => @columns);




1;
