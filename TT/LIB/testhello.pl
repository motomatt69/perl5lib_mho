#!/usr/bin/perl -w
use strict;
use Template;

my $tt = Template->new(PRE_PROCESS => 'header.ttc',
                       POST_PROCESS => 'footer.ttc',
                       INCLUDE_PATH => ['c:\perl5lib_mho\TT\SRC',
                                        'c:\perl5lib_mho\TT\LIB'])
                    || die Template->error(),"\n";

my $input = 'hello.tt';
my $vars = {author => 'Matthias Hofmann',
            title => 'Hello',
            bgcol => '#FF6600',
            year => '2010',
            };

my $dest = 'c:\perl5lib_mho\TT\DEST\hello.html';
my $test = $tt->process($input, $vars, $dest) || $tt->error();

my $dummy;
