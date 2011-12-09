package PPEEMS::SHOPDWG::c_bpscsv2dstv;
use strict;
use warnings;
use PPEEMS::STL::stl_eintrag;
use PPEEMS::STL::Bauteile;

use File::Slurp;
use Moose;
BEGIN {extends 'Patterns::MVC::Controler'};

sub bpscsv2dstv_liste{
    my ($self, $p) = @_;
    
    my @ls = File::Slurp::read_file($p);
    
    @ls = map{[split ';', $_]} @ls;
    $self->{ls} = \@ls;
    
    my ($anr) = $ls[0]->[0] =~ m/(\d{6})/;
    $self->set_stklistekopf($anr);
    $self->set_ts($ls[0]->[1]);
    $self->set_tsbez($ls[0]->[2]);
    $self->set_dat($ls[0]->[3]); 
    
    shift @ls; #Erste Zeile raus
    
    for my $z (@ls){
        if ($z->[0] eq 'Z'){
            my $vl = $z->[14];
            my $vb = $z->[15];
            my $vh = $z->[16];
            
            my $hpos = $z->[2];
            #Hauptpositionszeile
            for my $l (@ls){
                if ($l->[0] eq 'W' && $l->[4] eq $hpos){
                    $l->[0] = 'H';
                    $l->[25] = $vl;
                    $l->[26] = $vb;
                    $l->[27] = $vh;
                }
            }
            #ASatzzeile
            for my $l (@ls){
                if ($l->[0] eq 'A' && $l->[1] eq $hpos){
                    $l->[0] = 'del'
                }
            }
            $z->[0] = 'del'
        }
    }
    
    my @bpsls = grep{$_->[0] ne 'del'} @ls;
    
# dstv Bezeichnungen
    my $mem = PPEEMS::STL::bauteile ->new();
    
    for my $l (@bpsls){
        if ($l->[0] ne 'A'){
            $l = $mem->set_vals($l);
        }
    }
    
    my $dummy
}
    

1;
