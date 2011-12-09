package MISC::BLTR::ral_deci2hex;
use strict;

get_hexastr();

sub get_hexastr {
    my @raldezi = (75,63,106);
    
    my %d2h = (1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
                     10 => 'a', 11 => 'b', 12 => 'c', 13 => 'd', 14 => 'e', 15 => 'f'); 
    
    my $ralhexa = '#';
    foreach my $col (@raldezi) {
        my $val0 = int($col / 16);
        my $val1 = $col - ($val0 * 16);
        $ralhexa .= "$d2h{$val0}"."$d2h{$val1}";
        print $ralhexa,"\n";
    }
}


1;