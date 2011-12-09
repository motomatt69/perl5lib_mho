package PPEEMS::DB::PPEEMS::zz_revision;
use strict;
use warnings;

use base 'PPEEMS::DB::PPEEMS::Base';

__PACKAGE__->table('zz_revision');

my @columns = qw(revision
                 nr
                 alias
                 );

__PACKAGE__->columns(All        => @columns);
__PACKAGE__->columns(Essential  => @columns);




1;
