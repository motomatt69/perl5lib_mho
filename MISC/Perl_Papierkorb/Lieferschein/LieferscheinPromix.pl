#!/usr/bin/perl -w
use strict;
use Lieferschein::Promix qw(getKopfHandle getLieferHandle);

my $dbh = Lieferschein::Promix::connect();

my $kh = getKopfHandle($dbh);
my $lh = getLieferHandle($dbh);

my $lsnr = '99498677';

$kh->execute($lsnr);
my @lsko = $kh->fetchrow_array();
$kh->finish();
print "$lsko[0] : $lsko[1] \n\n";

$lh->execute($lsnr);
while (my @lo = $lh->fetchrow_array()) {
    my $str = join ' - ', @lo;
    print "$str \n";
}
$lh->finish();
