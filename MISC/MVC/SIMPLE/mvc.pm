package MISC::MVC::SIMPLE::mvc;
use strict;
use warnings;

use MISC::MVC::SIMPLE::view;
use MISC::MVC::SIMPLE::controler;
use MISC::MVC::SIMPLE::model;

use Moose;
BEGIN {extends 'Patterns::MVCSimple'};

sub _mvcitems {
    return{
        view => {class => 'MISC::MVC::SIMPLE::view',
                defines => {io => [qw/lesen/]}
        },
        controler => {class => 'MISC::MVC::SIMPLE::controler',
                    defines => {io => [qw/readfile/]}
        },
        model => {class => 'MISC::MVC::SIMPLE::model',
        }
    }   
}



1;
