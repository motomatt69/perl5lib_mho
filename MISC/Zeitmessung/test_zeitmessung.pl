#!/usr/bin/perl -w
use strict;
package Zeitmessung;
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;

Zeitmessung->mk_accessors qw(start ende dauer Gesdauer);



package main;
use Time::HiRes qw(gettimeofday tv_interval);

my $Ed = Zeitmessung->new ({start => 'braun', ende => 3});
my $Stallion = Zeitmessung->new ({start => 'schwarz', ende => 26});
my $Gesdauer = Zeitmessung->new;

print $Ed->get_start,"\n";
$Stallion->set_dauer('Heinz Dieter');
print $Stallion->get_start,"\n";
print $Stallion->get_dauer,"\n";
$Ed->set_start('gruen');
print $Ed->get_start,"\n";
print $Ed->get_dauer,"\n";
my $start = [gettimeofday];
$start = @$start[0];
$Gesdauer -> set_start($start);
#$Gesdauer -> set_ende([gettimeofday]);


print $Gesdauer -> get_start;




