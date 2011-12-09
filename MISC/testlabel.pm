package RDK8FT::CARDS::label;
use strict;
use warnings;
use File::Slurp;

use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(tsnr));

sub set_printfile{
    my ($self) = @_;
    
    my @dirs = qw( C: dummy);
    my $f = 'tl1.prn';
    my $p = File::Spec->catfile(@dirs, $f);
    $self->{p} = $p;
    
    my @ls;
    $ls[0] = "\n";
    $ls[1] = "N\n";
    
    
    
    #for (my $y = 25; $y <= 550; $y+= 25){
    #    my $lhori = "LO10,$y,800,2\n";
    #    push @ls, $lhori;
    #    my $thori = "A50,$y,0,1,1,1,N,".'"'."$y".'"'."\n";
    #    push @ls, $thori;
    #}
    #
    #for (my $x = 25; $x <= 800; $x+= 25){
    #    my $lvert = "LO"."$x,10,2,550\n";
    #    push @ls, $lvert;
    #    my $tvert = "A"."$x,50,1,1,1,1,N,".'"'."$x".'"'."\n";
    #    push @ls, $tvert;
    #}
    
    
    push @ls, "A"."50,50,0,c,1,1,N,".'"'."Hannes ist der Beste  O".'"'."\n";
    push @ls, "A"."50,180,0,c,1,1,N,".'"'."Hannes ist der 2.Beste  O".'"'."\n";
    push @ls, "A"."50,300,0,c,1,1,N,".'"'."Hannes ist der 3.Beste  O".'"'."\n";
    
    
    
    push @ls, "B"."100,400,0,1,2,2,80,N,".'"'."Hannes ist der Beste".'"'."\n";
        
    
    push @ls, qq(P1\n);
    File::Slurp::write_file($p, @ls);
}

sub _printout{
    my ($self) = @_;
    
    system 'copy '.$self->{p}.' LPT1:';
}
1;


package main;
use strict;

my $label = RDK8FT::CARDS::label-> new();
$label->set_printfile();
$label->_printout();
