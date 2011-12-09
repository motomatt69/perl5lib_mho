package point;
use strict;
use Moose;

has 'x' => (isa => 'Int', is => 'rw', required => 1);
has 'y' => (isa => 'Int', is => 'rw', required => 1);

sub clear{
    my ($self) = @_;
    $self->x(0);
    $self->y(0);
}



package point3d;
use Moose;

extends 'point';

has 'z' => (isa => 'Int', is => 'rw', required => 1);

after 'clear' => sub {
    my ($self) = @_;
    $self->z(0);
};


package main;
my $point = point->new(x => 1, y => 2);
print "Coordinates are ", $point->x, " , ", $point->y,"\n";
$point->clear;
print "Coordinates are ", $point->x, " , ", $point->y,"\n";
my $point3d = point3d->new(x => 3, y => 5, z => 7);
print "Coordinates are ", $point3d->x, " , ", $point3d->y," , ", $point3d->z,"\n";
