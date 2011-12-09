package PROFILE::PROF_DB::PROFILE::ral;
use strict;
use warnings;
use base 'PROFILE::PROF_DB::PROFILE::Base';

__PACKAGE__->table('ral');

my @columns = qw(id bez nr r g b hexastr);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;