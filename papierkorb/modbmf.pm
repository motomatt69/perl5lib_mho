package PPEEMS::SHOPDWG::modbmf::edit;
use strict;
use warnings;
use Moose;
use File::Slurp;

has 'outbmf'  => (isa => 'Str', is => 'rw', required => 1);
has 'basebmf' => (isa => 'Str', is => 'rw', required => 1);
has 'ldef'    => (isa => 'ArrayRef', is => 'ro', required => 0);
has 'tdef'    => (isa => 'ArrayRef', is => 'ro', required => 0);
has 'outls'   => (isa => 'ArrayRef', is => 'rw', required => 1,
                  default => \&start_outls,
                  );

sub start_outls{
    my ($self) = @_;
    
    my @outls;
    $outls[0] = "ausgabe:".$self->{outbmf}."\n";
    $outls[1] = "lade:".$self->{basebmf}."\n";
    
    return \@outls;
}

sub set_area{
    my ($self, $aref) = @_;
    
    my $area = "schonfläche:"   .$aref->{nr}.","
                                .$aref->{xl}.","
                                .$aref->{xr}.","
                                .$aref->{yu}.","
                                .$aref->{yo}.","
                                .$aref->{type}.","
                                .$aref->{pen}."\n";
    
    $self->_array($area, 'areas');
}

sub fillarea{
    my ($self, $faref) = @_;
    
    my $fillarea = "ladea:".$faref->{path}.","
                           .$faref->{area_nr}.","
                           .$faref->{anchor}."\n";
    
    $self->_array($fillarea, 'fillareas');
}


sub set_line{
    my ($self, $lref) = @_;
    
    my ($pen, $type, $rapo);
    if (defined $lref->{ldef}){
        $pen  = $self->{ldef}[$lref->{ldef}]{pen};
        $type = $self->{ldef}[$lref->{ldef}]{type};
        $rapo = $self->{ldef}[$lref->{ldef}]{rapport}; 
    }
    else{
        $pen  = $lref->{pen};
        $type = $lref->{type};
        $rapo = $lref->{rapport}; 
    }
        
    my $line = "linie:" .$pen.","
                        .$type.","
                        .$rapo.","
                        .$lref->{x0}.","
                        .$lref->{y0}.","
                        .$lref->{x1}.","
                        .$lref->{y1}."\n";
    
    $self->_array($line, 'lines');
}

sub set_text{
    my ($self, $tref) = @_;
    
    my ($winkel, $pen, $hgt, $hbv, $art, $neigw, $anchor, $rahmen);
    if (defined $tref->{tdef}){
        $winkel = $self->{tdef}[$tref->{tdef}]{winkel};
        $pen    = $self->{tdef}[$tref->{tdef}]{pen};
        $hgt    = $self->{tdef}[$tref->{tdef}]{hgt};
        $hbv    = $self->{tdef}[$tref->{tdef}]{hbv};
        $art    = $self->{tdef}[$tref->{tdef}]{art};
        $neigw  = $self->{tdef}[$tref->{tdef}]{neigw};
        $anchor = $self->{tdef}[$tref->{tdef}]{anchor};
        $rahmen = $self->{tdef}[$tref->{tdef}]{rahmen};      
    }
    else{
        $winkel = $tref->{winkel};
        $pen    = $tref->{pen};
        $hgt    = $tref->{hgt};
        $hbv    = $tref->{hbv};
        $art    = $tref->{art};
        $neigw  = $tref->{neigw};
        $anchor = $tref->{anchor};
        $rahmen = $tref->{rahmen};
    }
    
    my $text = "text:"  .$tref->{text}.","
                        .$tref->{x0}.","
                        .$tref->{y0}.","
                        .$winkel.","
                        .$pen.","
                        .$hgt.","
                        .$hbv.","
                        .$art.","
                        .$neigw.","
                        .$anchor.","
                        .$rahmen."\n";
    
    $self->_array($text, 'texts');
}

sub set_textfit{
    my ($self, $tref) = @_;
    
    my $textfit = "textmiteinpassen:" .$tref->{text}.","
                        .$tref->{x0}.","
                        .$tref->{y0}.","
                        .$tref->{winkel}.","
                        .$tref->{pen}.","
                        .$tref->{hgt}.","
                        .$tref->{hbv}.","
                        .$tref->{art}.","
                        .$tref->{neigw}.","
                        .$tref->{anchor}.","
                        .$tref->{rahmen}.","
                        .$tref->{range}."\n";
    
    
    $self->_array($textfit, 'textsfit');
}

sub set_replace_text{
    my ($self, $rtref) = @_;
    
    my $textrep = "ersetzen:"   .$rtref->{sgtyp}.","
                                .$rtref->{minnc}.","
                                .$rtref->{maxnc}.","
                                .$rtref->{key}.","
                                .$rtref->{such}.","
                                .$rtref->{ersetze}.","
                                .$rtref->{mit}."\n";
    
    $self->_array($textrep, 'textsrep');
}

sub _array{
    my ($self, $val, $bez) = @_;
    
    if ($self->{$bez}){
        my @lines = @{$self->{$bez}};
        push @lines, $val;
        $self->{$bez} = \@lines;
    }
    else{
        $self->{$bez} = [$val]
    }
}

sub finish{
    my ($self) = @_;
    
    my @outls = @{$self->{outls}};
 
    push @outls, @{$self->{areas}};
    push @outls, @{$self->{fillareas}};
    push @outls, @{$self->{lines}};
    push @outls, @{$self->{texts}};
    push @outls, @{$self->{textsfit}};
    push @outls, @{$self->{textsrep}};
    
    push @outls, "ende\n";
    
    my @progdirs = qw(c: programme offlmod);
    my $batchp = File::Spec->catdir(@progdirs, 'todo.inp');
    
    my $offlmod = $ENV{OFFLMOD};
    File::Slurp::write_file($batchp, @outls);
    system "$offlmod c:\\programme\\offlmod\\todo.inp";
}

package PPEEMS::SHOPDWG::modbmf::sizes;
use strict;
use warnings;
use Moose;

has 'bmfs'  => (isa => 'ArrayRef', is => 'ro', required => 1);

sub get_sizes{
    my ($self) = @_;
    
    my $hpgl2a = $ENV{HPGL2A};
    for my $bmf (@{$self->{bmfs}}){
        
        my $cmd_str = $hpgl2a.' -extrem '.$bmf;
        my $aus = `$cmd_str`;
        
        my ($pw, $ph, $dx0, $dy0, $dx1, $dy1) =
        $aus =~ m/hpgl2.cfg\)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)/x;
        
        $bmf->{pw} = $pw;
        $bmf->{ph} = $ph;
        $bmf->{x0} = $dx1 + $dx0;
        $bmf->{y0} = $dy1 + $dy0;
     
        
        
        
        my $dummy;
    }
    
    
}

1;
