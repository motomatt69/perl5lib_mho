package PROFILE::DB::PROFILE::ral;
use strict;
use warnings;
use base 'PROFILE::DB::PROFILE::base';

__PACKAGE__->table('ral');

my @columns = qw(id bez nr r g b hexastr);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;