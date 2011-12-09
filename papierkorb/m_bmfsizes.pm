package PPEEMS::SHOPDWG::m_bmfsizes;
use strict;
use warnings;

use Moose;

has 'bmfpaths'  => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'bmfs'      => (isa => 'HashRef', is => 'ro', required => 0);

use Patterns::Observer qw(:subject);

sub get_sizes{
    my ($self) = @_;

    my $hpgl2a = $ENV{HPGL2A};
    my %bmfs;
    for my $bmfpath (@{$self->{bmfpaths}}){
        
        my $cmd_str = $hpgl2a.' -extrem '.$bmfpath;
        my $aus = `$cmd_str`;
        
        my ($pw, $ph, $dx0, $dy0, $dx1, $dy1) =
        $aus =~ m/hpgl2.cfg\)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)/x;
        
        $bmfs{$bmfpath}->{pw}  = $pw;
        $bmfs{$bmfpath}->{ph}  = $ph;
        $bmfs{$bmfpath}->{dx0} = $dx0;
        $bmfs{$bmfpath}->{dy0} = $dy0;
    }
$self->{bmfs} = \%bmfs;
    
}

sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}
1;


