package Pferde;
use strict;

sub new {
    my $class = $_[0];
    my $self = bless {} , $class;
    return $self
}

sub recieveMessage {
    my ($self, $notifier, $message) = @_;
    if (index($message,'Gras') ne -1) {
        print "Pferd: $message? Na ja, Heu wäre besser\n";
    }
    if (index($message,'Mais') ne -1) {
        print "Pferd: $message?  Mais schmeckt mir überhaupt nicht\n Ich geh woanders hin!\n";
        $notifier->delobserver($self)
    }
}
1;