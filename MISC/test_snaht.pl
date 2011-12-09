#!/usr/bin/perl -w
use strict;
use File::Slurp;
use MHO_DB::TABS;

my @dirs = qw(c: dummy);
my $f = 'alstom.inp';
my $p = File::Spec->catfile(@dirs, $f);
my @lines = read_file($p);

@lines = grep{$_ =~ m/HWS/} @lines;
@lines = map {[split ',', $_]} @lines;

my $cdbh = MHO_DB::TABS->new();

for my $l (@lines){
    my ($nh) = $l->[0] =~ m/HWS(\S*)/;
    $nh =~ s/\*/X/g;
    my ($hws) = $cdbh->pr_hws_dat->search(nh => $nh);
    if ($hws) {
        
        my $r_db = $hws->r();
        $l->[7] = $r_db;
        $l->[8] = $l->[6] - $l->[7];
    }
    else{
        print "$nh\n";
    }
}

my @diff = grep {$_->[8] != 0} @lines;

map {print $_->[0].'_'.$_->[6].'_'.$_->[7]."\n"} @diff;
my $dummy;



