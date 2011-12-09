#!/usr/bin/perl -w
use strict;
package ente;
use DesignPatterns::Strategy qw(defineStrategy);
sub new{
    my ($class) = @_;
    return bless {}, $class;
}

ente->defineStrategy(Fliegen => ['fliegen']);
ente->defineStrategy(Quaken => ['quaken']);
                     
package stockentenverhalten;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub fliegen {
    my ($self) = @_;
    print "Fliege mit Flügel";
    
}
sub quaken {
    my ($self) = @_;
    print "quake super";
}

package gummientenverhalten;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub quaken {
    my ($self) = @_;
    print "quitsche";
}
sub fliegen {
    my ($self) = @_;
    print "Fliege nicht";
}

package main;
my $sv = stockentenverhalten->new();
my $gv = gummientenverhalten->new();

my $Stockente = ente->new();
$Stockente->setFliegen($sv);
$Stockente->setQuaken($sv);

my $Gummiente = ente->new();
$Gummiente->setFliegen($gv);
$Gummiente->setQuaken($gv);

for my $ente ($Stockente, $Gummiente) {
    $ente->fliegen_Fliegen();
    print " und ";
    $ente->quaken_Quaken();
    print "\n";
}




    