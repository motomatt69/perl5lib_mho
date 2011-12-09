#!/usr/bin/perl -w
use strict;
use File::Copy;


my $rv = 'c:';
my @rds = qw(c: dummy pdf);
    
my $f = 'wzheader_filled.pdf';
my $rp = File::Spec->catfile(@rds, $f);



my $sv = '//server-bocad3d/auftrag/';   
my $sds = ('/temp/');

my $sp = File::Spec->catdir($sv, $sds);

if (!-d $sp){
    mkdir $sp
}
$sp = File::Spec->catpath($sv, $sds, $f);
$sp = File::Spec->canonpath($sp);
 
File::Copy::copy($rp, $sp) or die "Copy failed: $!";   