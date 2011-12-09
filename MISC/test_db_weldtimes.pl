use strict;

use DB::WELDTIMES::TABS;
use DB::MHO_DB::TABS;
use DBI;


#my $dbh = DB::MHO_DB::TABS->new();
my $dbh = DB::WELDTIMES::TABS->new();

#my $dbh = DBI->connect('dbi:mysql:weldtimes:server-perl','mho','geheim');


my $dummy;