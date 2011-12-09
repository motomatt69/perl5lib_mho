package RDK8FT::shop_status;
use strict;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::K;
my $konst = RDK8FT::K->new();
use bigint;

sub shopstatus_exc2db{
    my ($class, $z) = @_;
    
    my $alsto = $z->[1];
        
    my $cdbh = RDK8FT::DB::RDK8FTP->new();
    my ($bts) = $cdbh->bauteil->search(alstom_id => $alsto);
    my $bt_id = $bts->bauteil_id();
    my ($bt) = $cdbh->bauteilinfo->search ({bauteil => $bt_id});
    
    my %bit_change;
    $bit_change{in_av} = $konst->in_av();
    $bit_change{kt} = $konst->kleinteile();
    $bit_change{zu} = $konst->zuschnitt();
    $bit_change{schl} = $konst->schlosser();
    $bit_change{schw} = $konst->schweisser();
    $bit_change{mal} = $konst->maler();
    
    for my $key (keys %bit_change){
        my $stat_new = $bt->edit_bauteilstatus('|', $bit_change{$key});
        $bt->update();
    }
}
        
        
1;
