package PPEEMS::SHOPDWG::m_prepbmf;
use strict;
use warnings;
use Moose;
use Patterns::Observer qw(:subject);
use PPEEMS::SHOPDWG::m_modbmf;

has 
has 'zng' => (isa => 'ArrayRef', is => 'ro', required => 0);

sub teilzngs2bmf{
    my ($self) = @_; 

    my @zng = @{$self->{zng}};
    my $cnt = 1;
    
    for my $blatt (@zng){
        my $frame = $blatt->{frame};
        my $tpl = $self->{m_db}->get_single_template($frame);
        
        my ($v, $dirs, $f) = File::Spec->splitpath($tpl->{bmfpath});
        my $basebmf = $dirs.$f;        
        
        my $outbmf = '/dummy/bmf/1test'.$cnt.'.bmf_';
        
        my $bmf = PPEEMS::SHOPDWG::m_modbmf->new(outbmf => $outbmf,
                                                 basebmf => $basebmf);
        $bmf->set_outlines();
        my $pxcm = $bmf->pxcm();
        
        my %teilzngs = %{$blatt->{teilzngs}};
        my %boxes = %{$blatt->{boxes}};
        
        for my $key (sort keys %boxes){
            my $tplpw = $blatt->{pw};
            my $tplph = $blatt->{ph};
            
            my $xl = ($boxes{$key}->[1][0]) / $pxcm;
            my $xr = ($tplpw - $boxes{$key}->[3][0]) / $pxcm;
            my $yu = ($boxes{$key}->[1][1]) / $pxcm;
            my $yo = ($tplph - $boxes{$key}->[3][1]) / $pxcm;
            
            $bmf->set_area({nr => $key,
                            xl => $xl,
                            xr => $xr,
                            yu => $yu,
                            yo => $yo,
                            type => 0,
                            pen => 1});
            
            my ($v, $dirs, $f) = File::Spec->splitpath($teilzngs{$key});
            my $subbmf = $dirs.$f;        
        
            $bmf->fillarea({path => $subbmf,
                            area_nr => $key,
                            anchor => 5});
        }
        $bmf->finish();
        $cnt++;
    }
    
    
    
    my $dummy;
}    
1;
