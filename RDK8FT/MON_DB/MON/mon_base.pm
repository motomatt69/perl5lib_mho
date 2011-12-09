package RDK8FT::MON_DB::MON::mon_base;
use strict;

use base 'Class::DBI';

__PACKAGE__->connection('dbi:mysql:mho:server-sql','mho','geheim');



1;

