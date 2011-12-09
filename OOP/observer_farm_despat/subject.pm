package subject;
use strict;
use DesignPatterns::Observer qw(:subject);


sub new {
    my $class = $_[0];
    my $self = bless {}, $class;
    return $self
}

    
sub Es_gibt_Gras {
    my ($self) = @_;
    print "Bauer sagt: Gras für alle!\n";
    $self->notify('gras_fuer_alle')
}

sub Es_gibt_Mais {
    my ($self) = @_;
    print "Bauer sagt: Mais für alle!\n";
    $self->notify('mais_fuer_alle')
}



sub delobserver {
    my ($self, $observer)=@_;
    my $observer_ref=$self->{'Observer'};
    @$observer_ref = grep {$_ ne $observer} @$observer_ref;
}
    
1;