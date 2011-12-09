#!/usr/bin/perl -w
use strict;
my $fred = person->new;
$fred->name('Fred');


package person;
use fields qw[name volk aliases];

sub new {
    my $class = shift;
    my person $self = fields::new(ref $class || $class);
                                  $self->{name}= 'unbenannt';
                                  $self->{volk}='unbekannt';
                                  $self->{aliases}=[];
                                  return $self;
}

sub name {
    my person $self = shift;
    $self ->{name} = shift if @_;
    return $self->{name};
}


package wizard;
use base "person";
use fields qw(stoff farbe kugel);

my wizard $magier1 = fields::new("wizard");

$magier1->name('Gandalf');
$magier1->{farbe}=('grau');


print $magier1->{name},"\n";
print $magier1->{farbe},"\n";