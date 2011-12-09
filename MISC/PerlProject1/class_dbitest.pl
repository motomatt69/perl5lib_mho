package RDK8FT::DBI;
use strict;

use base 'Class::DBI';
#bei wendeler
__PACKAGE__->connection('dbi:mysql:mho:server-sql','mho','geheim');

package RDK8FT::DBI::Umsetz_RDK8FT;
use strict;
use base 'RDK8FT::DBI::base';

RDK8FT::DBI::Umsetz_RDK8FT->table('Umsetz_RDK8FT');
RDK8FT::DBI::Umsetz_RDK8FT->columns(All => qw/id bez regex modul/);
RDK8FT::DBI::Umsetz_RDK8FT->columns(Essential => qw/id bez regex modul/);
