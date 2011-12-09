package PROFILE::CROSEC::m_csv2boc3d;
use strict;
use DB::MHO_DB::TABS;
use File::Spec;
use File::Slurp;
use Patterns::Observer qw(:observer);
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(vals));

sub set_csv{
    my ($self) = @_;
    
    my $vals_ref = $self->{vals};
    my %vals = %$vals_ref;
    my $bez = $vals{bez};
    $self->{bez} = $bez;
    my ($reihe, $nh) = $bez =~ /^(HWS|QWS|TWS)(\d+\*\d+\*\d+\*\d+)/;
    $nh =~ s/\*/X/g;
    $reihe = lc $reihe;
    $self->{reihe} = $reihe;
    my $tab = 'pr_'.$reihe.'_dat';
    $self->{tab} = $tab;
    
    my $cdbh = DB::MHO_DB::TABS->new();
    my ($hws) = $cdbh->$tab->find_or_create({nh => $nh});
   
        $hws->h($vals{h});
        $hws->b($vals{b});
        $hws->ts($vals{ts});
        $hws->tg($vals{tg});
        $hws->r($vals{aw});
        $hws->G($vals{G});
        $hws->U($vals{U});
        $hws->A($vals{A});
        $hws->ASteg($vals{ASteg});
        $hws->Iy($vals{Iy});
        $hws->Wy($vals{Wy});
        $hws->i_y($vals{iy});
        $hws->Iz($vals{Iz});
        $hws->Wz($vals{Wz});
        $hws->i_z($vals{iz});
        $hws->Sy($vals{Sy});
        $hws->Sz($vals{Sz});
        $hws->Vzd235($vals{Vzd235});
        $hws->Vzd355($vals{Vzd355});
        $hws->SyFl($vals{Syfl});
        $hws->aw235($vals{aw235});
        $hws->aw355($vals{aw355});
        $hws->expval3d($vals{expval3d});
        $hws->expvalps($vals{expvalps});
        
        $hws->update();
   
    $self->_write_csvps();
    $self->_write_csv3d();
}

sub _write_csvps{
    my ($self) = @_;
    
    my $tab = $self->{tab};
    
    my $cdbh = DB::MHO_DB::TABS->new();
    my $dbh = $cdbh->dbh();
        
    my $sth = $dbh->prepare(qq( SELECT expvalps
                                FROM $tab
                                ORDER BY nh));
    $sth->execute();
    
    my @lines;
    $lines[0] = '"A;ALPHA;B;C;D1;D2;G;H;IIX;IIY;IX;IY;M;NEIG;PROFIL;PTYPE;R1;R2;S;SX;SY;T;TAN;W1;W2;W3;WX;WY;"'."\n";
    
    while (my $row = $sth->fetchrow_arrayref()){
        push @lines, $row->[0]."\n";
    }
    
    #my $volps = '//server-bocad/';
    my @dirsps = qw(//server-bocad/ bocad-PS lists catalog export);
    #my $dirps = File::Spec->catdir(@dirsps);
    my $f = $self->{reihe}.'_profile_fuer_bps.csv';
    #my $pps = File::Spec->catpath($volps, $dirps, $f);
    my $pps = File::Spec->catfile(@dirsps, $f);
    
    
    my $outputps = write_file( $pps, @lines);
}

sub _write_csv3d{
    my ($self) = @_;
    
    my %vals = %{$self->{vals}};
    
    my $f = lc($self->{bez});
    $f =~ s/\*/x/g;
    $f .= '.csv';
    
    #my $vol3d = '//server-bocad/';
    my @dirs3d = qw(//server-bocad/ Auftraege csv_profilreihen);
    #my $dir3d = File::Spec->catdir(@dirs3d);
    my $p3d = File::Spec->catfile(@dirs3d, $f);
    
    my $output3d = write_file( $p3d, $vals{expval3d});
}

1;    
    

