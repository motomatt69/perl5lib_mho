package STATIK::RAL::m_ral;
use strict;

use PROFILE::PROF_DB::PROFILE;
use Moose;
BEGIN {extends 'Patterns::MVC::Model'};

has cdbh      	=> (is => 'ro', default => sub {PROFILE::PROF_DB::PROFILE->new()});
has ral_data    => (isa => 'ArrayRef', is => 'rw', lazy => 1, default => \&db2m_ral_data);

sub read_ral_data{
    my ($self) = @_;
    
    my @rals_db = $self->{cdbh}->ral->retrieve_all();
    
    my @rals;
    foreach my $r (@rals_db) {
        my $tmp->[0] = $r->nr;
           $tmp->[1] = $r->bez;
           $tmp->[2] = $r->hexastr;
        push @rals, $tmp;
    }
    
    $self->ral_data(\@rals);
    
    $self->notify('obs_ral_data');
}
            

1;