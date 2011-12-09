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
    print "Pferd: Gras für alle? Na ja, Heu wäre besser\n";
}

sub mais_fuer_alle {
    my ($self, $notifier) = @_;
    print "Pferd: Mais für alle?  Mais schmeckt mir überhaupt nicht\n Ich geh woanders hin!\n";
    $notifier->deleteObserver($self)
}

1;