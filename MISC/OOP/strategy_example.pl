#!/usr/bin/perl -w
use strict;

package Strategy;
use Moose::Role;
requires 'execute';
 
 
package FirstStrategy;
use Moose;
with 'Strategy';
 
sub execute {
    print "Called FirstStrategy->execute()\n";
}
 
 
package SecondStrategy;
use Moose;
with 'Strategy';
 
sub execute {
    print "Called SecondStrategy->execute()\n";
}
 
 
package ThirdStrategy;
use Moose;
with 'Strategy';
 
sub execute {
    print "Called ThirdStrategy->execute()\n";
}
 
 
package Context;
use Moose;
 
has 'strategy' => (
    is => 'rw',
    does => 'Strategy',
    handles => [ 'execute' ],  # automatic delegation
);
 
 
package StrategyExample;
use Moose;
 
# Moose's constructor
sub BUILD {
    my $context;
 
    $context = Context->new(strategy => 'FirstStrategy');
    $context->execute;
 
    $context = Context->new(strategy => 'SecondStrategy');
    $context->execute;
 
    $context = Context->new(strategy => 'ThirdStrategy');
    $context->execute;
}
 
 
package main;
 
StrategyExample->new;

