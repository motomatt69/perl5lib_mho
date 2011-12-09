use strict;

my @vals = qw(eins zwei drei);
$vals[5] = undef;

my $str = $vals[1]. $vals[4]."\n";

print $str;