package BANK::DB::STRUCT::Base;
use strict;
use warnings;

use base 'Class::DBI';

__PACKAGE__->connection('DBI:mysql:database=kontos;host=localhost','root','');


1;
