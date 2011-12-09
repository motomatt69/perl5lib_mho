use strict;

use DB::SWD;
use Benchmark  qw( :all);

my $count = 2;
my $t = timeit($count, sub{
    my $dbh = DB::SWD->new->dbh();

    my $sth = $dbh->prepare(q/SELECT * FROM hv_aposzng_rev
                            where baugruppe = 233/);
    $sth->execute();

    my $tab = $sth->fetchall_arrayref();
});

print "$count loops of other code took:",timestr($t),"\n";

my $dummy;