#!/usr/bin/perl -w
use strict;

my @size = (600, 300, 20 ,30);

my $crosec = blechtraeger->new(\@size);

my $mw = MainWindow->new();
my $CS_disp = $mw 



package blechtraeger;

sub new{
    my ($class, $size_ref) = @_;
    my $self = {h =>  $size_ref->[0],
                b =>  $size_ref->[1],
                ts => $size_ref->[2],
                tg => $size_ref->[3],
               };
    bless $self, $class;
    set_points();
    
    return $self;
} 
    
sub set_points{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}); 
    my $p1x = 0;
    my $p1y = 0;
    my $p2x = $p1x + $b;
    my $p2y = $p2x + $tg;
    
    my $p3x = $p1x + ($b / 2 - $ts / 2); 
    my $p3y = $p1y + $tg;
    my $p4x = $p3x + $ts;
    my $p4y = $p3y + ($h - 2 * $tg);
    
    my $p5x = $p1x;
    my $p5y = $p1y + ($h - $tg);
    my $p6x = $p5x + $b;
    my $p6y = $p5y + $tg;
    
    $self->{p1x => $p1x,
            p2x => $p2x,
            p3x => $p3x,
            p4x => $p4x,
            p5x => $p5x,
            p6x => $p6x,
           }
}
    
    
    

