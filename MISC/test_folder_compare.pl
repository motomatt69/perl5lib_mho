use strict;
use warnings;

use Compare::Directory;

my $p1 = 'C:\dummy\1';
my $p2 = 'C:\dummy\1';

my $comp = Compare::Directory->new($p1, $p2);
my $res = $comp->cmp_directory();


my $dummy;