package PROFILE::PROF_DB::PROFILE::Base;
use strict;
use warnings;

use base 'Class::DBI';

__PACKAGE__->connection('dbi:mysql:mho:server-perl','mho','geheim');



1;
