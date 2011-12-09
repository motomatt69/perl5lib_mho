package PPEEMS::SHOPDWG::ctrl_bmf;
use strict;
use Moose;

extends 'PPEEMS::SHOPDWG::ctrl_main';
#has 'm_modbmf'    => (isa => 'Object', is => 'ro', required => 1);
#has 'm_db'        => (isa => 'Object', is => 'ro', required => 0);
#has 'm_nest'      => (isa => 'Object', is => 'ro', required => 1);
#has 'm_prepbmf'   => (isa => 'Object', is => 'ro', required => 1);
 
#sub set_m_db{
#    my ($self, $m_db) = @_;
#    
#    $self->{m_db} = $m_db;
#}
 
 
sub template_sizes{
    my ($self) = @_;
    
    my $bmfpaths = $self->{m_db}->get_all_template_bmf_paths();
    
    $self->{m_modbmf}->bmfpaths($bmfpaths);
    my $bmf_sizes = $self->{m_modbmf}->get_sizes();
    $self->{m_db}->set_sizes($bmf_sizes, 'zz_vorlagen');  
}
#
#
#
#sub nest_bmf{
#    my ($self) = @_;
#    
#    #teilzng Größe ermitteln und in DB schreiben
#    $self->{m_db}->teilzngs($self->{view}->{selteilzngs});
#    my $bmfpaths = $self->{m_db}->get_teilzng_paths();
#    $self->{m_modbmf}->bmfpaths($bmfpaths);
#    my $bmf_sizes = $self->{m_modbmf}->get_sizes();
#    $self->{m_db}->set_sizes($bmf_sizes, 'zz_teilzngs');
#    
#    #Schachtelvorgang
#    $self->{m_nest}->teilzngsizes($bmf_sizes);
#    $self->{m_nest}->nest();
#    my @zng = @{$self->m_nest->zng()};
#    
#    my $cnt = 1;
#    #teilzngs auf bmf plazieren
#    for my $blatt (@zng){
#        my $frame = $blatt->{frame};
#        my $tpl = $self->{m_db}->get_single_template($frame);
#        
#        my ($v, $dirs, $f) = File::Spec->splitpath($tpl->{bmfpath});
#        my $basebmf = $dirs.$f;        
#        
#        my $outbmf = '/dummy/bmf/1test'.$cnt.'.bmf_';
#        
#        my $bmf = PPEEMS::SHOPDWG::m_modbmf->new(outbmf => $outbmf,
#                                                 basebmf => $basebmf);
#        $bmf->set_outlines();
#        my $pxcm = $bmf->pxcm();
#        
#        my %teilzngs = %{$blatt->{teilzngs}};
#        my %boxes = %{$blatt->{boxes}};
#        
#        for my $key (sort keys %boxes){
#            my $tplpw = $blatt->{pw};
#            my $tplph = $blatt->{ph};
#            
#            my $xl = ($boxes{$key}->[1][0]) / $pxcm;
#            my $xr = ($tplpw - $boxes{$key}->[3][0]) / $pxcm;
#            my $yu = ($boxes{$key}->[1][1]) / $pxcm;
#            my $yo = ($tplph - $boxes{$key}->[3][1]) / $pxcm;
#            
#            $bmf->set_area({nr => $key,
#                            xl => $xl,
#                            xr => $xr,
#                            yu => $yu,
#                            yo => $yo,
#                            type => 0,
#                            pen => 1});
#            
#            my ($v, $dirs, $f) = File::Spec->splitpath($teilzngs{$key});
#            my $subbmf = $dirs.$f;        
#        
#            $bmf->fillarea({path => $subbmf,
#                            area_nr => $key,
#                            anchor => 5});
#        }
#        $bmf->finish();
#        $cnt++;
#    }
#    
#    
#    
#    my $dummy;
#    
#    
#    
#}
#

# 
#    
1;