package MISC::tracewindow;
use strict;

sub new{
    my ($class, $parent) = @_;
    my $self = bless{}, $class;
    
    $self->{trace_t} = $parent->Scrolled("Text");
    
    
    
    $self->{trace_t}->configure(background => 'black',
                                foreground => 'white');
    
    return $self;
}

sub grid{
    my ($self, $r, $lastc) = @_;
    
    my $csp = $lastc + 1;
    $self->{trace_t}->grid(-row => $r,
                           -column => 0,
                           -columnspan => $csp,
                           -sticky => "nsew");
    
}

sub printtrace{
    my ($self, $text) = @_;
    $self->{trace_t}->insert('end', $text);
}
1;