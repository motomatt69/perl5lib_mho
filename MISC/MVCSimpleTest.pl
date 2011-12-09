#!/usr/bin/perl -w
use strict;

package main;
use TK;

my $mw = MainWindow->new();
my $mvc = MyMVC->new(widget => $mw);
$mvc->init();

MainLoop();

package MyMVC;

use Moose;

BEGIN {extends 'Patterns::MVCSimple'};

sub _mvcitems {
    return{
        view =>{class => 'MyView',
                defines => {IO => [qw/lesen schreiben loeschen/]}
                },
        controller => {class => 'MyControler',
                       defines => io => [qw/readfile writefile deletefile/]
                       },
        model =>{class => 'MyModel'}
    };
}

package MyView;
use Moose;
BEGIN {extends 'Patterns::MVC::View'};

sub init {
    my ($self) = @_;
    
    my $widget = $self->widget($self->MyMvC);    
}

