use strict;
use warnings;
use Sort::Naturally;


my @list = ('lkw 10' , 'lkw 2' , 'lkw 13');

my @sorted = nsort(@list);

my $nr = $sorted[-1];

if ($nr =~ m/(\d+)/){
    my $zahl = $1;
    $zahl ++;
    $nr =~ s/(\d+)/$zahl/;
}


my $dummy;