package PPEEMS::STATISTICS::v_statistics;
use strict;

use Tk;
use Tk::Utils::Grid;
use Tk::Chart::Lines;
use Tk::Chart::Bars;

use Moose;
BEGIN {
    extends 'GUI::SWD::App::View';
    __PACKAGE__->inheritStrategy();
}

has 'mw'        => (isa => 'Object',  is => 'rw', required => 0);

sub init{
    my ($self) = @_;
    my $mw = $self->widget($self->mvcname());
    
    my (undef, $fo, $fm, $fu) = configGrid(
        $mw =>         {-row => [qw(16 16 400v 32)],
                        -col => [qw(16 768v 16)]},
        
        $mw->Frame()    => {
            -row        => [qw(16)],
            -col        => [qw(768v)],
            -grid       => [1, 1],
        },
        
        $mw->Frame()    => {
            -row        => [qw(400v)],
            -col        => [qw(768v)],
            -grid       => [2, 1],
        },
        
        $mw->Frame()=>{
            -row        => [qw(32)],
            -col        => [qw(768v)],
            -grid       => [3, 1],
        },
    ); 
    
    (my ($pa),
    ) = configGrid(
        $fm->Scrolled('Pane',
                      Name => 'fred',
                      -scrollbars => 'e',
                      -sticky => 'nswe',
                      -gridded => 'xy',
                        ) =>{
                        -row        => [qw(400v)],
                        -col        => [qw(768v)],
                        -grid       => [0, 0]
                       },
    );

    for my $blo (qw/1 2 ges/){
        $self->{'ch_'.$blo} = $pa->Lines()->pack (qw/ -fill both -expand 1/);  
        $self->{'ch_'.$blo}->configure( -background     => 'snow',
                                        -titleposition  => 'left',
                                        -xlabel         => 'KW',
                                        -ylabel         => 'Tonnage',
                                        -linewidth      => 2,
                                        -ylongticks     => 1,
                                        -yticknumber    => 10,
                                        -spline     => 1,
                                        -bezier     => 1, 
                                    );
    };
    
    $self->{ch_1}   ->configure(-title => 'Block 1');
    $self->{ch_2}   ->configure(-title => 'Block 2');
    $self->{ch_ges} ->configure(-title => 'Block 1 + 2');
    
    $self->{ch_avg} = $pa->Bars()->pack (qw/ -fill both -expand 1/);  
    $self->{ch_avg}->configure( -background     => 'snow',
                                -title          => 'Block 1 + 2, Tonnage pro KW',
                                -titleposition  => 'left',
                                -xlabel         => 'KW',
                                -ylabel         => 'Tonnage',
                                -linewidth      => 2,
                                -ylongticks     => 1,
                                -yticknumber    => 5,
                            );
}

sub _scroll_charts{
    my ($sb, $scrolled, $chs, @args) = @_;
    $sb->set(@args);
    my ($top, $bottom) = $scrolled->yview();
    for my $ch (@{$chs}){
        $ch->yviewMoveTo()
    }
}

sub chart{
    my ($self, $not) = @_;
    
    my @legend = $not->legend();
    my %datas = $not->datas();
    
    for my $blo (qw/1 2 ges/){
        $self->{'ch_'.$blo}->set_legend(-title => 'Legende',
                                -data  => \@legend,
                                -titlecolors => 'blue',
                                );
        
        $self->{'ch_'.$blo}->set_balloon();
        
        my @data = @{$datas{$blo}};
        $self->{'ch_'.$blo}->plot( \@data );
    }
    
    $self->{ch_avg}->set_legend(-title => 'Legende',
                                -data  => ['Zeichnungen versendet', 'Bauteile schwarz'],
                                -titlecolors => 'blue',
                                );
        
    $self->{ch_avg}->set_balloon();
        
    my @data = @{$datas{'avg'}};
    $self->{ch_avg}->plot( \@data );
    
    my $dummy;
}
1;