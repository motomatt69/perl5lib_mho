package Kuehe;
use strict;
use DesignPatterns::Observer qw (:observer);

sub new {
    my $class = $_[0];
    my $self = bless {} , $class;
    return $self
}

sub gras_fuer_alle {
    my ($self, $notifier) = @_;
    print "Kuh: Gras für alle? mmmh Gras ist mein Leibgericht\n";
}

sub mais_fuer_alle {
    my ($self, $notifier) = @_;
    print "Kuh: Mais für alle? Ich ess alles\n";
}
1;
