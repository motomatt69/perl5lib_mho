package PROFILE::CROSEC::m_qws_batch;
use strict;
use MHO_DB::TABS;


#use base 'DesignPatterns::MVC::Model';
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw());

sub get_values{
    my ($self) = @_;
    
    my $cdbh = MHO_DB::TABS->new();
    
    my @qws_profile = $cdbh->pr_qws_dat->retrieve_from_sql(qq{ r > 0}) ;
    
        
    my %qws_vals;        
    for my $qws (@qws_profile){
        my $bez = 'QWS'.$qws->nh();
        $qws_vals{$bez} = [$qws->h(),
                           $qws->b(),
                           $qws->ts(),
                           $qws->tg(),
                           $qws->r()];
    }
    
    return %qws_vals;
}
1;    
    

