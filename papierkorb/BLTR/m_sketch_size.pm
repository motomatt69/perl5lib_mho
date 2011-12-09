package PROFILE::CROSEC::m_sketch_size;
use strict;

use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(sketch_size));


sub set_sketch_size{
    my($self, $sketch_size) = @_;
    
    $self->{sketch_size} = $sketch_size;
}

sub set_h{
    my($self, $h) = @_;
    
    $self->{h} = $h;
}

sub set_b{
    my($self, $b) = @_;
    
    $self->{b} = $b;
}
                       

sub get_sketchvals{
    my ($self) = @_;
    
    $self->calc_factor_und_startpunkt();
    
    my %sketchvals = (fac => $self->{fac},
                      startx => $self->{startx},
                      starty => $self->{starty},
                      sk_h => $self->{sk_h},
                      sk_b => $self->{sk_b},
                      );
    
    return %sketchvals;
}

sub calc_factor_und_startpunkt{
    my ($self) = @_;
    
    my $sketch_size_ref = $self->{sketch_size};
    my %sketch_size = %$sketch_size_ref;
    my $sk_h = $sketch_size{sk_h};
    my $sk_b = $sketch_size{sk_b};
    
    $self->{sk_h} = $sk_h;
    $self->{sk_b} = $sk_b;
    
    my ($h, $b) = ($self->{h}, $self->{b});
    
    my $fac_x = ($sk_b * 0.8) / $b;
    my $fac_y = ($sk_h * 0.8 / $h);
    
    my $fac = ($fac_x <= $fac_y) ? $fac_x : $fac_y;
    $self->{fac} = $fac;
    
    $self->{startx} = $sketch_size{sk_startx};
    $self->{starty} = $sketch_size{sk_starty};
}    
1;    
    

