#!/usr/bin/perl -w
use strict;
use PPEEMS::DB::PPEEMS;
#use Scalar::Util qw /looks_like_number/;
#use Math::Round qw/round/;
#my $wert1 = 22;
#my $wert2 = 40;
#my $trenner = ';';
#
#my $str = sprintf "%10s %10s %10s\n", ($wert1, $trenner, $wert2);
#print $str;
#
#for my $num (1..120){
#    my $rest = 5 - length $num;
#    my $vorn = "x" x $rest;
#    print "$vorn$num\n";
#    
#}
#my @vs =(qw(00 01 02 03 04 05 06));
#
#my $act = '02';
#my @v_mod = grep{$_ <= $act} @vs;
#for my $v (@vs){
#    if ($v <= $act){
#        push @v_mod, $v
#    }
#}


#my $val = undef;
#my @data;
#
#push @data, $val ;
#push @data, $val ;
#
#my $v = 12345.23212;
#
#my $w = sprintf "%d", $v;

#my @array = [0,0,0,0,0,1100, 1000];
#my $start = map{last if ($_ > 0)} @array;

#my $text1 = "wefqwgeqrgvqer\n";
#my $text2 = "wgfwersgewrgfewrfg\n";
#my $text3 = $text1.$text2;
#print "$text3";


#my @array =([0,1,2,3,4,5,6],
#            [0,1,2,3,4,5,6],
#            [0,1,2,3,4,5,6],
#            [0,1,2,3,4,5,6],
#            [0,1,2,3,4,5,6],
#            [0,1,2,3,4,5,6],
#            );
#
#my @teil;
#for my $r (@array){
#    my @row = @{$r};
#    my @erste3 = @row[0..2];
#    push @teil, [@erste3];
#}

#my @vals = ([212.5, 12256545.8],
#            [214551.8, 'test'],
#            [123_123_123, undef],
#            );
#
#
#@vals = map{[map{looks_like_number $_ ? sprintf "%d", $_ : $_ } @{$_}]} @vals;
#
#
#my @array;
#my $val =  316.5;
#my $val_dbase = round($val);
#print $val_dbase,"\n";
#

my @array = (0,1,2,3,4,5,10);
my $var = 2;
my $var1 = $var || 'ersatz';

my $arrayref = \@array;
my $anzahl = $#{ $arrayref };

print "fertig\n";
my $dummy;