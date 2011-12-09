package Zeitmessung::Zeitmessung;

use strict;
use Time::HiRes qw(gettimeofday tv_interval);

sub new {
    my ($class) = @_;
    my $self = bless {'start'   =>([gettimeofday]),
                      'now_old' =>([gettimeofday])}, $class;
    return $self;
}

sub get_start {
    my ($self) = @_;
    return $self->{'start'}
}

sub set_ende {
    my ($self) = @_;
    $self->{'ende'} = ([gettimeofday]);
    $self->set_dauer;
}

sub get_ende {
    my ($self) = @_;
    return $self->{'ende'}
}

sub set_dauer {
    my ($self) = @_;
    $self->{'dauer'} = (tv_interval $self->{start}, $self->{ende})
}

sub get_dauer {
    my ($self) = @_;
    return $self->{'dauer'}
}

sub get_teilzeit{
    my ($self) = @_;
    
    my $now = ([gettimeofday]);
    my $diff = (tv_interval $self->{now_old}, $now);
    $self->{now_old} = $now;
    
    return $diff 
}

sub get_zwischenzeit{
    my ($self) = @_;
    
    my $now = ([gettimeofday]);
    my $diff = (tv_interval $self->{start}, $now);
    
    return $diff 
}

1;