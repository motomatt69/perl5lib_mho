use strict;
use warnings;

use Data::Sorting qw( :basics :arrays :extras );
use Data::Dumper;

#my @records = ( 
#    { 'rec_id'=>3, 'name'=>{'first'=>'Bob', 'last'=>'Macy'} },
#    { 'rec_id'=>1, 'name'=>{'first'=>'Sue', 'last'=>'Jones'} },
#    { 'rec_id'=>2, 'name'=>{'first'=>'Al',  'last'=>'Jones' } },
#  );
#my @ordered = sorted_array( @records, 'rec_id' );
#
##print Dumper(@ordered);
#print "#####################################################################\n";
#
#@ordered = sorted_array( @records, ['name','last'], ['name','first'] );
#
##print Dumper(@ordered);
#print "#####################################################################\n";


my @tab = ([3, 2, 3],#, 4, 5, 6, 7, 8, 9, 1, 0],
           [3, 5, 4],# 8, 9, 4, 1, 2,22,12,15],
           [1, 5, 8],# 5, 8, 5, 8, 5, 8,58, 5],
           [0, 0, 0],
           ['a', 'b', 'c'],
           ['a', 'd', 'c'],
           ['a', 'b', 'e'],
           ['a', 'b', 'c'],
           [3, 5, 5],
           );

my @tmp;

my $c_max = @{$tab[0]} - 1;
my $r_max = $#tab;
for my $r (0..$r_max){
    my $row = $tab[$r];
    for my $c (0..$c_max){
       $tmp[$r]->{$c} = $row->[$c] 
    }
}

my @orderedtmp = sorted_array(@tmp,
                              -order => 'ascending', ['0'],
                              -order => 'descending', ['2'],
                              -order => 'ascending', ['1'],
                              );

my @orderedtab = @{wieder_2dim_array(\@orderedtmp)};


printtab(\@orderedtab);
print "#####################################################################\n";

my $dummy;

sub wieder_2dim_array{
    my $tmpref = shift;
    
    my @tmp = @$tmpref;
    
    my @tab;
    my $r_max = $#tmp;
    for my $r (0..$r_max){
        my %row = %{$tmp[$r]};
        for my $c (sort keys %row){
           $tab[$r]->[$c] = $row{$c} 
        }
    }
    
    return \@tab
}
    


sub printtab{
    my $tabref = shift;
    
    my @tab = @$tabref;
    
    my $c_max = @{$tab[0]} - 1;
    my $r_max = $#tab;
    for my $r (0..$r_max){
        my $row = $tab[$r];
        for my $c (0..$c_max){
           #printf "%4d", $row->[$c],
           print $row->[$c]
        }
        print "\n"
    }
    
    
    
    
}