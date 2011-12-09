package Moose::ctrl_main;
use strict;
use Moose::ctrl_bmf;
use Moose;

has 'm_db'     => (isa => 'Object', is => 'rw', required => 1);
has 'ctrl_bmf' => (isa => 'Object', is => 'rw', required => 0);# default => \&set_ctrl_bmf);
    
sub BUILD{
    my ($self) = @_;
    
    my $m_db = $self->{m_db};
    my $ctrl_bmf = Moose::ctrl_bmf->new('m_db' => $m_db);
    $self->{ctrl_bmf} = $ctrl_bmf;
}

sub get_data{
    my ($self) = @_;
    
    $self->{ctrl_bmf}->get_data;
}
1;




