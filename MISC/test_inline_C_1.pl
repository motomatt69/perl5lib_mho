use strict;

use Helpers::Timing::timing;

my $max = 20000;
my $z;

my $p_time = Helpers::Timing::timing->new();

$z = p_test($max);

print sprintf "p_test: %3.3f sec\n", $p_time->period(), "\n";


my $c_time = Helpers::Timing::timing->new();

$z = c_test($max);

print sprintf "c_test: %3.3f sec\n", $c_time->period(), "\n";




use Inline C => q{
    int c_test (int m){
        int x; int y; int z;
        for (x = 1; x <= m; x++){
            for (y = 1; y <= m; y++){
                z = x + y;
                //printf ("%d\n", z);
            }
        }
        
        //printf ("max: %d\n\n", m);
        //return;
        return (z);
    }
};

sub p_test{
    my ($max) = @_;
    
    for my $x (1..$max){
        for my $y (1..$max){
            my $z = $x + $y;
            #print "$z\n";
        }
    }
}