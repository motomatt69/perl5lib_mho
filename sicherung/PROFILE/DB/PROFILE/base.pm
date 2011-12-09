package PROFILE::DB::PROFILE::base;
use strict;
use warnings;

use base 'Class::DBI';

__PACKAGE__->connection('dbi:mysql:mho:server-sql','mho','geheim');



1;
