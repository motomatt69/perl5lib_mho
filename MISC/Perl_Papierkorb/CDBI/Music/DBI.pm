package CDBI::Music::DBI;
use strict;

use base 'Class::DBI';

__PACKAGE__->connection('DBI:mysql:host=server-sql;database=mho','mho','geheim');

package CDBI::Music::CD;
use base 'CDBI::Music::DBI';

__PACKAGE__->table('cdbi_cd');
__PACKAGE__->columns(All => qw/cdid artist title year/);





1;