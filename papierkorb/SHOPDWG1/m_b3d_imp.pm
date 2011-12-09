package PPEEMS::SHOPDWG1::m_b3d_imp;

use strict;

use File::RGlob;
use File::Slurp;

use Moose;
BEGIN {extends 'Patterns::MVC::Model'};

has datei   => (is => 'rw', isa => 'Str');

sub import_ascii_lists{
    my ($self) = @_;
    
    my $erg = $self->_import_list();
    my $res = $self->{result};
    
    if ($erg == 0){
        if ($res =~ m/^Liste nicht mit/ || $res =~ m/unterschiedlichen Stand/){
            $self->printtrace($res);
            return
        }
        elsif($res =~ m/Doppelte Alstom Positionen/){
            $self->printtrace($res);
            my @manylist = @{$self->{manylist}};
            map {$self->printtrace("$_\n")} @manylist;
            return
        }
    }
    
    #Bildschirmausgabe
    my %members_ascii = %{$self->{members_ascii}};
    map{my $str = sprintf   "%-3s%-6s %-3s%-6s %-4s%-6s %-5s%-12s\n",
                           ("ID:",$members_ascii{$_}->{ident} || q{},
                            "TS:",$members_ascii{$_}->{ts} || q{},
                            "Pos:",$members_ascii{$_}->{pos} || q{},
                            "Kenn:",$members_ascii{$_}->{kenn} || q{},
                            );
    $self->printtrace($str)
    } keys %members_ascii;
    
    $self->printtrace("$res\n")
}


sub _import_list{
    my ($self) = @_;
    
    my $linesref = $self->_read_ascii();
    my @lines = @$linesref;
    
    my $anzls = @lines;
    print "Struktur, Anzahl vor Bereinigung: $anzls\n";
    @lines = grep {$_ =~ m/\d{6}\| #6-stellige indentnr
                            \d{6}\|   #6-stellige tsnr
                            \d{5} \|   #5-stellige hposnr
                            \d{4}-\d{4}\| #apbposnr
                        /x} @lines;
    
    
    $anzls = @lines;
    print "Struktur, Anzahl nach Bereinigung: $anzls\n";
    
    map {$_ =~ s/\|/;/g} @lines;
    my @strukts = map {[split ';', $_]} @lines;
            
    #check doppelte Alstomeinträge;
    my @apbposs = grep {$_->[3] =~ m/\d{4}-\d{4}/} @strukts;
    my %double; 
    for my $p (@apbposs){
        my $apbpos = $p->[3];
        $double{$apbpos} += 1;
    }
    my @apbs = grep {$double{$_} > 1} keys %double;
    my @manylist;
    for my $apb (@apbs){
        my @b3ds = grep {$_->[3] eq $apb} @apbposs;
        for my $b3d (@b3ds){
            push @manylist, 'TS: '.$b3d->[1].' Pos: '.$b3d->[2].' Alstom_id: '.$b3d->[3].' Idend: '.$b3d->[0].' LeitIdend: '.$b3d->[4]
        }
    }
    
    if (@manylist){
        $self->{result} = "Doppelte Alstom Positionen vorhanden\n";
        $self->{manylist} = \@manylist;
        return 0
    }
    
    #check Einzelausschreibung
    for my $l (@strukts){
        my ($ts, $pos, $anz) = ($l->[1], $l->[2], $l->[4]);
        my @singleposs = grep {($_->[1] == $ts && $_->[2] == $pos && $_->[4] == $anz)} @strukts;
        
        my $anzsingleposs = @singleposs;
        if ($anz != $anzsingleposs){
            
            $self->{result} = "Liste nicht mit Einzelauflistung aus b3D ausgeschrieben\n";
            return 0
        }
    }
        
    my %members_ascii;
    for my $str (@strukts){
        my %member = ('ident'       => $str->[0],
                      'ts'          => $str->[1],
                      'pos'         => $str->[2],
                      'kenn'        => $str->[3],
                      'tsqt'        => $str->[4],
                      'prof'        => $str->[5],
                      'stal'        => $str->[6],
                      'assw'        => $str->[7],
                      'assq'        => $str->[8]
                     );
        
        $members_ascii{$str->[0]} = \%member; 
    }
    
    $self->{members_ascii} = \%members_ascii;
    $self->{result} = "Listenimport ok";

    return 1
}

sub _read_ascii{
    my ($self) = @_;
    
    my $file = $self->datei();
    
    if (!$file) {
        my $vol = '//server-bocad/AUFTRAEGE/';
        my @dirs = ($vol,
                    '090477_eemshaven_original',
                    'lists');
        
        my $p = File::Spec->catdir(@dirs);
        
        my $glob =  File::RGlob->new();
        $glob->file_include(sub {$_[1] =~ m/^struktur_list_\d{2}\.lis/});
        $glob->path($p);
        $glob->scan();        
        my @fs = @{$glob->get_files()};
        my @sortfs = sort {$a cmp $b} @fs;
         
        $file = pop @sortfs;
    }     
    
    my @lines = File::Slurp::read_file($file);
    
    map {$_ =~ s/\s*//g} @lines;
    map {$_ =~ s/^\|//} @lines;
    
    return \@lines;
}


sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}   
1;