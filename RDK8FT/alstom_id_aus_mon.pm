package RDK8FT::alstom_id_aus_mon;
use strict;

sub get_alstom_ids{
    my ($dbh_mon) = @_;
    my @mon_col_a;
    
    my $dbh = $dbh_mon->dbh();
    
    my $sth_tab = $dbh->prepare(q{
        SELECT position
        FROM monitor
        ORDER BY position
    });
    
    $sth_tab->execute;
    while (my @val = $sth_tab->fetchrow_array()){
        push @mon_col_a, $val[0];
    }
    $sth_tab->finish;
    
    return @mon_col_a;
}


1;