#!/usr/bin/perl -w
use strict;

use RDK8FT::DB::RDK8FTP;

my $db = RDK8FT::DB::RDK8FTP->new();

my @bundles = $db->bundle->retrieve_all();

my $dummy;