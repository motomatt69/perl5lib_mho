#!/usr/bin/perl -w

use strict;
use OOP::tree;

my ($TreeObj) = tree->new("c:\\dummy", \&showdir, \&showfile);
$TreeObj->tellroot();
$TreeObj->cruisetree();

sub showdir {
    print "Dirctory: $_[0] ...\n";
}

sub showfile {
    print "      File ...\n";
}
