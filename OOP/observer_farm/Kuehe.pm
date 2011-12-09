package Kuehe;
use strict;

sub new {
    my $class = $_[0];
    my $self = bless {} , $class;
    return $self
}

sub recieveMessage {
    my ($self, $notifier, $message) = @_;
    if (index($message,'Gras') ne -1) {
    print "Kuh: $message? Gras schmeckt gut\n"
    }
    if (index($message,'Mais') ne -1) {
    print "Kuh: $message? Ich fress alles\n"
    }
}
1;
