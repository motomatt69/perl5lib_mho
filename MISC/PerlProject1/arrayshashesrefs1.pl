#!/usr/bin/perl -w
use strict;

my @row1=(1,2,3);   #normaler array
my @row2=(4,5,6);   #normaler array
my @row3=(7,8,9);   #normaler array
my @cols=(\@row1,\@row2,\@row3);  #array von referenzierten arrays
my $table_ref=\@cols;      #referenzierter array 

print "2 x 3= ", $cols[1][2],"\n"; #zugriff auf array
print "1 x 2= ", $cols[0][1],"\n"; #zugriff auf array
print "2 x 3= ", $table_ref->[1][2],"\n"; #zugriff auf referenz


my $association_ref = {}; #hashreferenz deklarieren
$association_ref = {cat => 'nap', dog => 'gone', mouse => 'ball'};  #Refernez auf hash
print "When I say cat, you say: ", $association_ref->{cat}, "\n"; #Zugriff auf Hashreferenz
my %association = %$association_ref; #hash dereferenzieren
print "When I say dog, you say: ", $association{dog}, "\n"; #Zugriff auf Hashelement

my $behaviour_ref = {};
$behaviour_ref = {
                 cat => { nap => 'lap', eat => 'meat'},
                 dog => {prowl => 'growl', pool => 'drool'},
                 mouse => {nibble => 'kibble'},
                }; #hashreferenz in hashreferenz


print " A cat eats ", $behaviour_ref->{cat}->{eat},"\n"; #zugriff auf hashreferenz
my %behaviour = %$behaviour_ref; #hash dereferenzieren
print " A dog prowl ", $behaviour{dog}{prowl},"\n"; #zugriff auf hash



my$sub_ref = sub {print "Heeeeeeeere's $_[0]!\n"}; #refernez auf sub
$sub_ref->("lookin at you, kid"); #Zugriff auf subreferenz
