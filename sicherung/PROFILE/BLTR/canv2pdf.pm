package PROFILE::BLTR::canv2pdf;
use strict;

sub new {
    my ($class, $canv) = @_;
    my $self->{canv} = $canv;
    bless $self, $class;
    
    $self->create_pdf();
}
    
sub create_pdf{
    
    my ($self) = @_;
    my $canv = $self->{canv};
    
    
    my $dummy;
}

1;