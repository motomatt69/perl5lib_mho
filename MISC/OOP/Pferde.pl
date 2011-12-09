#!/usr/bin/perl -w
use strict;

package main;
my $ed = pferd->new;
my $stallion = pferd->new(farbe => 'schwarz');
my $steed = pferd->new(farbe=>'graubraun');
$steed -> clone(besitzer => 'EquuGen Guild, Ltd.');
$ed->clone(farbe => 'gruen'); 


print $stallion->{farbe},"\n";
print $ed->{farbe},"\n";
print $steed->{besitzer},"\n";

package pferd;

sub new {
    my $class = shift;
    my $self = {
                farbe => "rotbraun",
                beine => 4,
                besitzer => undef,
                @_,
               };
    return bless $self, $class;
}

sub clone {
    my ($self, $key, $val) = @_;
    $self->{$key}=$val;
    return $self->{$key};
}
