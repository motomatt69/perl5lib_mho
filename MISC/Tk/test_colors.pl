use strict;
use warnings;

my $hex = 'FF';
#print hex($hex),"\n";

my $dezi = 100;
$dezi += 200;

$hex = sprintf "%x", $dezi;
#print $hex;


my $col = "90EE90";

my ($r, $g, $b) = $col =~ m/(\S{2})(\S{2})(\S{2})/;

$r = hex($r);
my $fak_r = $r / 100;
$g = hex($g);
my $fak_g = $g / 100;
$b = hex($b);
my $fak_b = $b / 100;

my @col_dezi;
for (my $t = 100; $t >= 0 ; $t -= 1){
    push @col_dezi, [int($r - $t * $fak_r), int($g - $t * $fak_g), int($b - $t * $fak_b)];
}

my @col_hex;
my $cnt = 1;
for my $row (@col_dezi){
    push @col_hex, $cnt;
    my $color = sprintf("#%02X%02X%02X", $row->[0], $row->[1], $row->[2]);

    push @col_hex, $color;
    $cnt ++
}



my $dummy