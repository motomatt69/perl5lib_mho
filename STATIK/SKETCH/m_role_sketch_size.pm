package STATIK::SKETCH::m_role_sketch_size;
use strict;

use Moose::Role;

has sketch_size => (isa => 'HashRef',  is => 'rw', auto_deref => 1);
has obj_size => (isa => 'HashRef',  is => 'rw', auto_deref => 1);

has fac     => (isa => 'Any', is => 'rw');
has startx  => (isa => 'Any', is => 'rw');
has starty  => (isa => 'Any', is => 'rw');
has sk_h    => (isa => 'Any', is => 'rw');
has sk_b    => (isa => 'Any', is => 'rw');
                 
sub _sketchvals{
    my ($self) = @_;
    
    my %sketch_size = $self->sketch_size();
    my $sk_h = $sketch_size{sk_h};
    my $sk_b = $sketch_size{sk_b};
    
    my %obj_size = $self->obj_size();
    
    my ($h, $b) = ($obj_size{h}, $obj_size{b});
    
    my $fac_x = ($sk_b * 0.8) / $b;
    my $fac_y = ($sk_h * 0.8 / $h);
    
    my $fac = ($fac_x <= $fac_y) ? $fac_x : $fac_y;
    $self->fac($fac);
    
    $self->startx($sketch_size{sk_startx});
    $self->starty($sketch_size{sk_starty});
    $self->sk_h($sk_h);
    $self->sk_b($sk_b);
}    
1;    
    

