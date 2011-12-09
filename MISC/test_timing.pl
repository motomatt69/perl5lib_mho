use strict;

use Helpers::Timing::timing;

my $t1 = Helpers::Timing::timing->new();

my $start = $t1->start();
print sprintf "%.3f" ,$start ,"\n";
sleep 1;

my $Zwischenzeit = $t1->split_time();
my $per1 = $t1->period();

sleep 2;

my $per2 = $t1->period();
my $ende = $t1->end();
my $dauer = $t1->duration();
my $dummy;


