package PROFILE::CROSEC::m_hws_batch;
use strict;
use MHO_DB::TABS;


#use base 'DesignPatterns::MVC::Model';
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw());

sub get_values{
    my ($self) = @_;
    
    my $cdbh = MHO_DB::TABS->new();
    
    
    my @hws_profile = $cdbh->pr_hws_dat->retrieve_all();
    
        
    my %hws_vals;        
    for my $hws (@hws_profile){
        my $bez = 'HWS'.$hws->nh();
        $hws_vals{$bez} = [$hws->h(),
                           $hws->b(),
                           $hws->ts(),
                           $hws->tg(),
                           $hws->r()];
    }
    
    return %hws_vals;
}
1;    
    

