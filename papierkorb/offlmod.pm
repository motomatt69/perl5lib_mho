package PPEEMS::SHOPDWG::offlmod;
use warnings;
use Moose;
use File::Slurp;

#fuer offlmod
has 'outbmf'  => (isa => 'Str',      is => 'rw', required => 0);
has 'basebmf' => (isa => 'Str',      is => 'rw', required => 0);
has 'ldef'    => (isa => 'ArrayRef', is => 'ro', required => 0, default => \&linedefault);
has 'tdef'    => (isa => 'ArrayRef', is => 'ro', required => 0, default => \&textdefault);
has 'outls'   => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'pxcm'    => (isa => 'Value',    is => 'ro', default => 28.3263245);
                  
sub linedefault{
    my ($self) = @_;
    
    my @linedefault = ({pen => 1, type => 0, rapport => 1},
                       {pen => 2, type => 0, rapport => 1},
                       {pen => 3, type => 0, rapport => 1},
                       {pen => 2, type => 1, rapport => 1},);
    
    return \@linedefault;
}

sub textdefault{
    my ($self) = @_;
    
    my @textdefault = ({winkel => 0, pen => 1, hgt => 0.8, hbv => 0.8, art => 1,
                        neigw => 90, anchor => 5, rahmen => 13},
                       {winkel => 0, pen => 2, hgt => 1.2, hbv => 0.8, art => 1,
                        neigw => 90, anchor => 5, rahmen => 13},
                       {winkel => 0, pen => 3, hgt => 1.6, hbv => 0.8, art => 1,
                        neigw => 90, anchor => 5, rahmen => 13},
                       );
    
    return \@textdefault;
}

#fuer sizes:
has 'bmfpaths'  => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'bmfs'      => (isa => 'HashRef', is => 'ro', required => 0);

sub BUILD{
    my ($self) = @_;
    
    if (($self->{outbmf}) && ($self->{basebmf})){
        my @outls;
        $outls[0] = "ausgabe:".$self->{outbmf}."\n";
        $outls[1] = "lade:".$self->{basebmf}."\n";
    
        $self->{outls} = \@outls;
    }
}

sub set_area{
    my ($self, $aref) = @_;
    
    if ($aref->{nr} < 200){
        my $area = "schonfläche:"   .$aref->{nr}.","
                                    .$aref->{xl}.","
                                    .$aref->{xr}.","
                                    .$aref->{yu}.","
                                    .$aref->{yo}.","
                                    .$aref->{type}.","
                                    .$aref->{pen}."\n";
        
        $self->_array($area, 'areas');
    }
    else{
        print "maximal 199 areas möglich\n;"
    }
}

sub fillarea{
    my ($self, $faref) = @_;
    
    my $fillarea = "ladea:".$faref->{path}.","
                           .$faref->{area_nr}.","
                           .$faref->{anchor}."\n";
    
    $self->_array($fillarea, 'fillareas');
}

sub fillareafit{
    my ($self, $faref) = @_;
    
    my $fillareafit = "ladee:". $faref->{path}.","
                                .$faref->{area_nr}.","
                                .$faref->{anchor}."\n";
    
    $self->_array($fillareafit, 'fillareasfit');
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
 
    if ($self->{areas})         {push @outls, @{$self->{areas}}};
    if ($self->{fillareas})     {push @outls, @{$self->{fillareas}}};
    if ($self->{fillareasfit})  {push @outls, @{$self->{fillareasfit}}};
    if ($self->{lines})         {push @outls, @{$self->{lines}}};
    if ($self->{texts})         {push @outls, @{$self->{texts}}};
    if ($self->{textsfit})      {push @outls, @{$self->{textsfit}}};
    if ($self->{textsrep})      {push @outls, @{$self->{textsrep}}};
    
    push @outls, "ende\n";
    
    my $cnt = 1;
    map { print "Zeile $cnt: $_";
         $cnt ++} @outls;
    
    my @progdirs = qw(c: programme offlmod);
    my $batchp = File::Spec->catdir(@progdirs, 'todo.inp');
    
    my $offlmod = $ENV{OFFLMOD};
    File::Slurp::write_file($batchp, @outls);
    system "$offlmod c:\\programme\\offlmod\\todo.inp";
}

    
sub get_sizes{
    my ($self) = @_;

    my $hpgl2a = $ENV{HPGL2A};
    my %bmfs;
    for my $bmfpath (@{$self->{bmfpaths}}){
        
        my $cmd_str = $hpgl2a.' -extrem '.$bmfpath;
        my $aus = `$cmd_str`;
        
        my ($pw, $ph, $d0x, $d0y, $d1x, $d1y) =
        $aus =~ m/hpgl2.cfg\)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)\s*
                ([\s-]\d+\.\d+)/x;
        
        $bmfs{$bmfpath}->{pw}  = $pw;
        $bmfs{$bmfpath}->{ph}  = $ph;
        $bmfs{$bmfpath}->{d0x} = $d0x;
        $bmfs{$bmfpath}->{d0y} = $d0y;
    }
    $self->{bmfs} = \%bmfs;
}

sub get_pxcm{
    my ($self) = @_;
    
    return $self->{pxcm};
}
1;
