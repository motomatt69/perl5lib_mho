package Moose::ctrl_bmf;
use strict;

use Moose;

has 'm_db'     => (isa => 'Object', is => 'rw', required => 1);

sub get_data{
    my ($self) = @_;
    
    my $data = $self->{m_db}->data();
    
    print "$data\n";
}


1;




