package Pferde;
use strict;
use DesignPatterns::Observer qw (:observer);

sub new {
    my $class = $_[0];
    my $self = bless {} , $class;
    return $self
}

sub gras_fuer_alle {
    my ($self, $notifier) = @_;
    print "Pferd: Gras f�r alle? Na ja, Heu w�re besser\n";
}

sub mais_fuer_alle {
    my ($self, $notifier) = @_;
    print "Pferd: Mais f�r alle?  Mais schmeckt mir �berhaupt nicht\n Ich geh woanders hin!\n";
    $notifier->deleteObserver($self)
}

1;