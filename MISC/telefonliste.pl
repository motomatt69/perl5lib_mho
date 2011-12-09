use strict;
use warnings;

use File::Slurp;

my $p = "c:\\dummy\\tel.csv";

my @lines = File::Slurp::read_file($p);

for my $line (@lines){
    chomp $line;
    my @l = split ';', $line ;
    
    print '$WENN RP~'.$l[0]."\n";
    print '    $I_VARI RP_TEL = "'.$l[1].'"'."\n";;
    print '    $I_VARI RP_FAX = "'.$l[2].'"'."\n";;
    print '$W_END'."\n";
    print "\n";
        
    my $dummy;
}



my $dummy;