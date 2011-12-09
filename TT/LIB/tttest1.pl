#!/usr/bin/perl -w
use strict;
use Template;

my $tt = Template->new(#PRE_PROCESS => 'header',
                       #POST_PROCESS => 'footer',
                       INCLUDE_PATH => ['c:\perl5lib_mho\TT\SRC',
                                        'c:\perl5lib_mho\TT\LIB']);

my $input = 'destruction.tt';
my $vars = {planet => 'Earth',
            captain => 'Protestnic Vogon Jeltz',
            time => 'two of your earth minutes'
            };

my $test = $tt->process($input,$vars) || $tt->error();

my $dummy;


