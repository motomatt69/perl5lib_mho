package subject;
use strict;

sub new {
    my $class = $_[0];
    my $self = bless {}, $class;
    return $self
}

sub addobserver {
    my ($self, $observer) = @_;
    
    my $observer_ref;
    push @$observer_ref, $observer;
    $self->{'Observer'}=$observer_ref;
    return
}
    
    
1;