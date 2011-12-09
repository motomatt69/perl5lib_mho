package RDK8FT::MON_DB::MON::Base;
use strict;

use base 'Class::DBI';

__PACKAGE__->connection('dbi:mysql:mho:server-perl','mho','geheim');



1;

