package STATIK::CROSEC::m_crosec;
use strict;

use Moose;

with 'STATIK::SKETCH::m_role_sketch_size';
with 'STATIK::CROSEC::ROLES::m_role_hws';


BEGIN {extends 'Patterns::MVC::Model'};



has reihe 	=> (isa => 'Str', is => 'rw');
has size 	=> (isa => 'HashRef', is => 'rw', auto_deref => 1,);

has snaht_pkte  => (isa => 'ArrayRef', is => 'rw', auto_deref => 1);
has pkte        => (isa => 'ArrayRef', is => 'rw', auto_deref => 1,);

has val_res => (isa => 'ArrayRef', is => 'rw', auto_deref => 1, trigger => \&_not_valres);
has cs_canv_dat => (isa => 'HashRef', is => 'rw', trigger => \&_not_cs_canv_dat);




sub validate{
    my ($self) = @_;
    
    $self->_hws_validate() if ($self->reihe() eq 'HWS');
}

sub _not_valres{
    my ($self) = @_;
    
    $self->notify('obs_valres')
}

sub _not_cs_canv_dat{
    my ($self) = @_;
    
    $self->notify('obs_cs_canv_dat')
}

sub calc_cs_canv_data {
    my ($self) = @_;
    
    my %size = $self->size();
    my %obj_size = ('h' => $size{h},
                    'b' => $size{b});
    $self->obj_size(\%obj_size);
    $self->_sketchvals();
    
    $self->_hws_cs_canv_data() if ($self->reihe() eq 'HWS');
}

sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}   
1;    
    

