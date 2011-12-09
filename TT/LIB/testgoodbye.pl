#!/usr/bin/perl -w
use strict;
use Template;

my $tt = Template->new(PRE_PROCESS => 'header.ttc',
                       POST_PROCESS => 'footer.ttc',
                       INCLUDE_PATH => ['c:\perl5lib_mho\TT\SRC',
                                        'c:\perl5lib_mho\TT\LIB']);

my $input = 'goodbye.tt';
my $vars = {author => 'Matthias Hofmann',
            title => 'We will meet again',
            bgcol => '#FF6600',
            year => '2010',
            };

my $dest = 'c:\perl5lib_mho\TT\DEST\goodbye.html';
my $test = $tt->process($input, $vars, $dest) || $tt->error();

my $dummy;
