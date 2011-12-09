package PROFILE::CROSEC::m_batch;
use strict;
use DB::MHO_DB::TABS;

use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(reihe));

sub get_values{
    my ($self) = @_;
    
    my $reihe = $self->{reihe};
    $reihe = lc $reihe;
    my $tab = 'pr_'.$reihe.'_dat';
    my $cdbh = DB::MHO_DB::TABS->new();
    
    
    my @profils = $cdbh->$tab->retrieve_all();
    
        
    my %vals;        
    for my $prof (@profils){
        my $bez = $reihe.$prof->nh();
        $vals{$bez} =     [$prof->h(),
                           $prof->b(),
                           $prof->ts(),
                           $prof->tg(),
                           $prof->r()];
    }
    
    return %vals;
}

1;    
    

