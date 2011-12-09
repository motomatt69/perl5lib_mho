package subject;
use strict;

sub new {
    my $class = $_[0];
    my $self = bless {}, $class;
    return $self
}

sub addobserver {
    my ($self, $observer) = @_; 
    #push @{$self->{'Observers'}}, $observer;
    my $observer_ref=$self->{'Observer'};
    push @$observer_ref, $observer;
    $self->{'Observer'}=$observer_ref;
    return
}
    
sub Es_gibt_Gras {
    my ($self) = @_;
    print "Bauer sagt: Gras für alle!\n";
    $self->notify('Gras für alle')
}

sub Es_gibt_Mais {
    my ($self) = @_;
    print "Bauer sagt: Mais für alle!\n";
    $self->notify('Mais für alle')
}
sub notify {
    my ($self, $message) = @_;
    my $observer_ref = $self->{'Observer'};
    
    for my $observer (@$observer_ref) {
        $observer->recieveMessage($self,$message);
    }
}

sub delobserver {
    my ($self, $observer)=@_;
    my $observer_ref=$self->{'Observer'};
    @$observer_ref = grep {$_ ne $observer} @$observer_ref;
}
    
1;