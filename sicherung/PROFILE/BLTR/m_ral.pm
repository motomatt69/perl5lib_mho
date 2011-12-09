package PROFILE::BLTR::m_ral;
use strict;
use PROFILE::DB::PROFILE;
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
PROFILE::BLTR::m_ral->mk_accessors(qw(ral_data));

sub db2m_ral_data{
    my($self) = @_;
    
    $self->{db} = PROFILE::DB::PROFILE->new();
    my @rals_db = $self->{db}->ral->retrieve_all;
    
    my @rals;
    foreach my $r (@rals_db) {
        my $tmp->[0] = $r->nr;
           $tmp->[1] = $r->bez;
           $tmp->[2] = $r->hexastr;
        push @rals, $tmp;
    }
    
    $self->{ral_data} = \@rals;
}
        
sub get_ral_data{
    my ($self) = @_;
    
    $self->db2m_ral_data();
    
    return $self->{ral_data}
}
    

1;