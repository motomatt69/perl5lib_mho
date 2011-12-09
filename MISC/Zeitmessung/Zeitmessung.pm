#!/usr/bin/perl -w
use strict;

package Zeitmessung;
#use base qw(Class::Accessor);
#__PACKAGE__->follow_best_practice;

#Zeitmessung->mk_accessors qw(start ende dauer);
use strict;
use Time::HiRes qw(gettimeofday tv_interval);

sub new {
    my ($class) = @_;
    my $obj = bless {'start' =>([gettimeofday])}, $class;
    return $obj;
}

sub get_start {
    my ($obj) = @_;
    return $obj->{'start'}
}

sub set_ende {
    my ($obj) = @_;
    $obj->{'ende'} = ([gettimeofday]);
    $obj->set_dauer;
}

sub get_ende {
    my ($obj) = @_;
    return $obj->{'ende'}
}

sub set_dauer {
    my ($obj) = @_;
    $obj->{'dauer'} = (tv_interval $obj->get_start, $obj->get_ende)
}

sub get_dauer {
    my ($obj) = @_;
    return $obj->{'dauer'}
}

1;