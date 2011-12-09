#!/usr/bin/perl -w
use strict;
use File::Spec;
use File::Basename;


my @files = glob('c:\\auftrag\\aus_archiv\\061032\\*bmf_');
for my $files (@files) {
    my $line = bmf_size($files);
    print "$line\n";
}

sub bmf_size {
    my $file = shift;
    
    my ($v, $d, $f) = File::Spec->splitpath($file);
    my ($bn, undef, undef) = fileparse($f, qr/(\.[^.]+)$/);
    my $cmd = 'C:\\auftrag\\aus_archiv\\061032\\hpgl2a.exe -extrem';
    my $cmd_str = $cmd . ' ' . $file;
    my $aus = `$cmd_str`;
    
    my ($info) = $aus =~ m/([^\n]+)File:/;
    return $info;
}