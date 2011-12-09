#!/usr/bin/perl -w
use strict;
package ente;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub setFlugverhalten{
    my($self, $v) = @_;
    $self->{Flugverhalten} = $v->fliegen();
}
sub setQuakverhalten{
    my($self, $v) = @_;
    $self->{Quakverhalten} = $v->quaken();
}


sub tu_fliegen {
    my($self) = @_;
    print "Ich fliege ", $self->{Flugverhalten};
}

sub tu_quaken{
    my ($self) = @_;
    print "Ich quake ", $self->{Quakverhalten};
}
    

package stockentenverhalten;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub fliegen {
    my ($self, $v) = @_;
    return " mit Flügel";
    
}
sub quaken {
    my ($self) = @_;
    return " super";
}

package gummientenverhalten;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub quaken {
    my ($self) = @_;
    return "quitschend";
}
sub fliegen {
    my ($self) = @_;
    return " nicht";
}

package totentenverhalten;
sub new{
    my ($class) = @_;
    return bless {}, $class;
}
sub quaken {
    my ($self) = @_;
    return "sehr still";
}
sub fliegen {
    my ($self) = @_;
    return " nicht sondern verwese";
}

package main;

my $sv = stockentenverhalten->new();
my $gv = gummientenverhalten->new();
my $tv = totentenverhalten->new();

my $Stockente = ente->new();
$Stockente->setFlugverhalten($sv);
$Stockente->setQuakverhalten($sv);

my $Gummiente = ente->new();
$Gummiente->setFlugverhalten($gv);
$Gummiente->setQuakverhalten($gv);

my $Ente1 = ente->new();
$Ente1->setFlugverhalten($gv);
$Ente1->setQuakverhalten($gv);

print "Umfrage1: \n";
foreach my $ente (($Stockente, $Gummiente)) {
    $ente->tu_fliegen();
    print "\n";
    $ente->tu_quaken();
    print "\n";
}
print "\nEnte1 stirbt!! \n\n";
$Ente1->setFlugverhalten($tv);
$Ente1->setQuakverhalten($tv);

print "Umfrage2: \n";
foreach my $ente (($Stockente, $Gummiente, $Ente1)) {
    $ente->tu_fliegen();
    print "\n";
    $ente->tu_quaken();
    print "\n";
}

my $dummy;


    