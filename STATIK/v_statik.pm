package STATIK::v_statik;
use strict;

use Tk;
use Tk::NoteBook;
use Tk::BrowseEntry;
#use Tk::Utils::Grid;

use STATIK::CROSEC::mvc_crosec;
use STATIK::SCHWERT::mvc_schwert;

use Moose;
BEGIN {extends 'Patterns::MVC::View';
       with 'Elch::Tk::Grid';};

with 'STATIK::RAL::v_role_ral';

has nbook        => (isa => 'Object', is => 'rw');
has mvc_act => (isa => 'Object', is => 'rw');

has lastsettings => (isa => 'HashRef', is => 'rw', auto_deref => 1);
has progact  => (isa => 'Str', is => 'rw');
has classact => (isa => 'Str', is => 'rw');

sub init{
    my ($self) = @_;
   
    my $mw = $self->widget($self->mvcname());
    $self->Widget(MW => $mw);
    
    $self->C_STATIK_read_last_settings();
    
    $self->grid(
        MW => {
            -row  => [qw(16 400v 32 16)],  -col  => [qw(16 576v 16)],
        },
        
            [MW => 'Frame'] => {-name => 'FO',     -row  => [qw(400v)],    -col  => [qw(576v)],
                                -grid => [1, 1],
            },
                
                [FO => 'NoteBook'] => {-name => 'NBook',
                                 -grid => [0, 0],
                                 -options => {('-background', 'white',)},
                },                    
                
            [MW => 'Frame'] => {-name => 'FU',     -row  => [qw(32)],    -col  => [qw(576v)],
                                -grid => [2, 1],
            },
                
                [FU => 'Button'] => {-grid => [0, 0],  -options => {('-text', "Farbe wählen",
                                                                     '-command',  sub{$self->_raise_ral_hlist()})}
                },
                [FU => 'Button'] => {-grid => [0, 1],  -options => {('-text', "beenden",
                                                                     '-command',  sub{$self->_save_settings('beenden')})}
                },
                
                
    );
                    #    [FL => 'Frame'] => {-name => 'FLO',    -row  => [qw(12 12 12 12
        #                                                        12 12 12 12)],    -col  => [qw(32 96)],
        #                        -grid => [0, 0],    -variable => \$flo,
        #    },
        #             
        #    [FL => 'Frame'] => {-name => 'FLM',   -row  => [qw(400v)],    -col  => [qw(128)],
        #                        -grid => [1, 0],    -variable => \$flm,
        #    },
        #    
        #    [FL => 'Frame'] => {-name => 'FLU',   -row  => [qw(12 12 12)],     -col  => [qw(64 64)],
        #                        -grid => [2, 0],    -variable => \$flu,
        #    },
        #        [FLU => 'Button'] => {-grid => [0, 0],  -options => {('-text', "drucken",
        #                                                              '-command',  sub{$self->_canv2pdf('print')})}
        #        },
        #        [FLU => 'Button'] => {-grid => [0, 1],  -options => {('-text', "pdf anzeigen",
        #                                                              '-command',  sub{$self->_canv2pdf('show')})}
        #        },
        #        [FLU => 'Button'] => {-grid => [1, 0],  -options => {('-text', "Farbe wählen",
        #                                                              '-command',  sub{$self->_raise_ral_hlist()})}
        #        },
        #        [FLU => 'Button'] => {-grid => [1, 1],  -options => {('-text', "batch",
        #                                                              '-command',  sub{$self->do_batch()})}
        #        },
        #        [FLU => 'Button'] => {-grid => [2, 0],  -options => {('-text', "csv bocad3d",
        #                                                              '-command',  sub{$self->do_csv2boc3d()})}
        #        },
        #        
        #    
        #[MW => 'Frame'] => {-name => 'FR',    -row  => [qw(400v)],        -col  => [qw(576v)],
        #                    -grid => [1, 2],    -variable => \$fr,
        #},
        
    
    $self->_raise_nbook;
}

sub _raise_nbook{
    my ($self) = @_;
    
    my $nbook = $self->Widget('NBook');
    my %ls = $self->lastsettings();
    my %progs = %{$ls{progs}};
    map {$nbook->add($_,
                     -label => $_,
                     -raisecmd => [$self, '_save_settings'])} keys %progs;
    
    #$self->progact($ls{lastprog});
    #$self->classact($ls{lastclass});
    
    $nbook->raise($ls{lastprog});
    $self->_start_prog();   
}

sub _start_prog{
    my ($self) = @_;
    
    my %ls = $self->lastsettings();
    
    my $prog = $ls{lastprog};
    $self->progact($prog);
    my $class = $ls{lastclass};
    
    my $nbook = $self->Widget('NBook');
    my $frame = $nbook->page_widget($prog);
    
    my %ls_glob = $self->lastsettings();
    my $e_vals_loc = $ls_glob{progs}->{$prog}{vals};
    my $mvc = $class->new(e_vals => $e_vals_loc);
    $self->mvc_act($mvc);
    $mvc->widgets($frame => [qw/Application/]);
    $mvc->init();
}

sub _save_settings{
    my ($self, $beenden) = @_;
    
    my $mvc_act = $self->mvc_act();
    return if (!$mvc_act);
    
    my $e_vals = $mvc_act->{view}{Application}{e_vals};
    $self->C_STATIK_write_settings($self->progact(), $e_vals);
    
    if ($beenden && $beenden eq 'beenden'){
        exit
    }
    else{
        my $nbook = $self->Widget('NBook');
        my $progact = $nbook->info("active");
    
        $self->C_STATIK_read_last_settings();
        $self->_start_prog();
    }
}


sub obs_lastsettings{
    my ($self, $not) = @_;
    
    $self->lastsettings($not->lastsettings());
}
1;