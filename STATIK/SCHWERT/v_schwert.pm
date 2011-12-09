package STATIK::SCHWERT::v_schwert;
use strict;

use Tk;

use Moose;
BEGIN {extends 'Patterns::MVC::View';
       with 'Elch::Tk::Grid';};

sub init{
    my ($self) = @_;
   
    my $mw = $self->widget($self->mvcname());
    $self->Widget(MW => $mw);
    
    $self->grid(
        MW => {
            -row  => [qw(16 400v 16)],  -col  => [qw(16 576v 16)],
        },
        
            [MW => 'Canvas'] => {-name => 'CANV',
                                 -grid => [0, 0],
                                 -options => {('-background', 'green',
                                              '-height', 100,
                                              '-width',  200)},
            },              
                
    );
}


1;