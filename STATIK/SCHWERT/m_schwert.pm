package STATIK::SCHWERT::m_schwert;
use strict;

use Moose;

BEGIN {extends 'Patterns::MVC::Model'};



sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}   
1;    
    

