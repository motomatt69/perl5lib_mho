package Misc::Tk::bltr;
use strict;
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(h b ts tg r poly));

#sub new{
#    my ($class, $size_ref) = @_;
#    my $self = {h =>  $size_ref->[0],
#                b =>  $size_ref->[1],
#                ts => $size_ref->[2],
#                tg => $size_ref->[3],
#                r => $size_ref->[4],
#               };
#    bless $self, $class;
#    set_points($self);
#    
#    return $self;
#} 
 
sub init{
    my ($self, $size_ref) = @_;
    $self->{h} =  $size_ref->[0],
    $self->{b} =  $size_ref->[1],
    $self->{ts} = $size_ref->[2],
    $self->{tg} = $size_ref->[3],
    $self->{r} = $size_ref->[4],
    
    set_poly($self);
}

sub set_poly{
    my ($self) = @_;
    
    my ($h, $b, $ts, $tg, $r) = ($self->{h}, $self->{b}, $self->{ts}, $self->{tg}, $self->{r}); 
    my @p1xy = (0,0);
    my @p2xy = ($p1xy[0] + $b, $p1xy[1]);
    my @p3xy = ($p1xy[0] + $b, $p1xy[1]+ $tg );
    my @p4xy = ($p1xy[0] + $b /2 + $ts / 2, $p1xy[1]+ $tg );
    my @p5xy = ($p1xy[0] + $b / 2 + $ts / 2, $p1xy[1]+ $h - $tg );
    my @p6xy = ($p1xy[0] + $b, $p1xy[1]+ $h - $tg );
    my @p7xy = ($p1xy[0] + $b, $p1xy[1]+ $h);
    my @p8xy = ($p1xy[0], $p1xy[1]+ $h);
    my @p9xy = ($p1xy[0], $p1xy[1]+ $h - $tg);
    my @p10xy = ($p1xy[0] + $b / 2 - $ts / 2, $p1xy[1]+ $h - $tg);
    my @p11xy = ($p1xy[0] + $b / 2 - $ts / 2, $p1xy[1] + $tg);
    my @p12xy = ($p1xy[0], $p1xy[1] + $tg);
    
    my @poly = (\@p1xy,\@p2xy,\@p3xy,\@p4xy,\@p5xy,\@p6xy,\@p7xy,\@p8xy,\@p9xy,\@p10xy,\@p11xy,\@p12xy);
    $self->{poly} = \@poly;
}
    
        
    
1;    
    

