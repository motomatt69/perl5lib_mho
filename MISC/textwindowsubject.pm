package MISC::textwindowsubject;
use strict;
use Patterns::Observer qw(:subject);

sub new{
    my ($class) = @_;
    
    return bless {}, $class;
}

sub set_trace{
    my ($self, $trace) = @_;
    
    $self->{trace} = $trace;
}




sub data{
    my ($self) = @_;
    
    for my $i (1..80){
        my $txt = $i." text\n";
        $self->{trace}->printtrace($txt);
    }
}

1;
