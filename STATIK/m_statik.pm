package STATIK::m_statik;
use strict;
use DB::MHO_DB::TABS;

use File::Temp;
use PDF::convert_pdf_version;

use Moose;

BEGIN {extends 'Patterns::MVC::Model'};

has cdbh => (isa => 'Object', is => 'ro', default => sub{DB::MHO_DB::TABS->new()});
has dbh  => (isa => 'Object', is => 'ro', default => sub{DB::MHO_DB::TABS->new()->dbh()});
has user => (isa => 'Str', is => 'rw');
has lastsettings => (isa => 'HashRef', is => 'rw');

has canv     => (isa => 'Object', is => 'rw');
has show_or_print => (isa => 'Str', is => 'rw');

sub read_last_settings{
    my ($self) = @_;
    
    my $user = $self->user();
    my %ls = (user => $user);
    
    $self->_user_anlegen_oder_finden($user);
    $self->_pruefen_ob_alle_programme_in_usersetting_sind();
    
    my $dbh = $self->dbh();
    
    my $sth = $dbh->prepare(qq(
            SELECT  c.name, c.klasse, a.hexastr,
                    a.reihe, a.nh, a.h, a.b, a.ts, a.tg, a.r
            FROM    statik_usersetting a
            JOIN    statik_user b ON a.user = b.user
            JOIN    statik_program c ON a.program = c.program
            WHERE   b.name = '$user'
            ORDER BY a.date DESC ));
    $sth->execute();
    
    while (my $rec = $sth->fetchrow_arrayref()){
        $ls{lastprog} = ($ls{lastprog}) ? $ls{lastprog} : $rec->[0];
        $ls{lastclass} = ($ls{lastclass}) ? $ls{lastclass} : $rec->[1];
        
        $ls{progs}->{$rec->[0]}{klasse}  = $rec->[1];
        $ls{progs}->{$rec->[0]}{vals}{hexastr} = $rec->[2];
        $ls{progs}->{$rec->[0]}{vals}{reihe}   = $rec->[3];
        $ls{progs}->{$rec->[0]}{vals}{nh}      = $rec->[4];
        $ls{progs}->{$rec->[0]}{vals}{h}       = $rec->[5];
        $ls{progs}->{$rec->[0]}{vals}{b}       = $rec->[6];
        $ls{progs}->{$rec->[0]}{vals}{ts}      = $rec->[7];
        $ls{progs}->{$rec->[0]}{vals}{tg}      = $rec->[8];
        $ls{progs}->{$rec->[0]}{vals}{r}       = $rec->[9];
    }
    
    $self->lastsettings(\%ls);
    
    $self->notify('obs_lastsettings');
    my $dummy;
}

sub _user_anlegen_oder_finden{
    my ($self, $user) = @_;
    
    my $dbh = $self->dbh();
    my ($userrec) = $dbh->selectrow_array(qq(
        SELECT name FROM statik_user WHERE name = '$user'));
    
    return if ($userrec);
    
    eval{
        $dbh->do(qq{INSERT INTO statik_user (name)
                                VALUES ('$user')});
    };
    if ($@){$self->printtrace("Datenbankfehler: ".$@."\n")}
    
    my ($user_id) = $dbh->selectrow_array(qq(
    SELECT user FROM statik_user WHERE name = '$user'));
    
    my @progs = @{$self->_programme_oder_user_auslesen('program')};
    
    for my $prog (@progs){
        eval{
        $dbh->do(qq(INSERT INTO statik_usersetting (user, program)
                                VALUES ($user_id, $prog)));
        };
        if ($@){$self->printtrace("Datenbankfehler: ".$@."\n")}
    }
}

sub _pruefen_ob_alle_programme_in_usersetting_sind{
    my ($self) = @_;
    
    my @progs = @{$self->_programme_oder_user_auslesen('program')};
    my @users = @{$self->_programme_oder_user_auslesen('user')};
    my $dbh = $self->dbh();
    
    for my $p (@progs){
        for my $u (@users){
            my ($rec) = $dbh->selectrow_array(qq(
                SELECT usersetting FROM statik_usersetting
                WHERE user = $u AND program = $p));
            next if ($rec);
            
            eval{
                $dbh->do(qq(INSERT INTO statik_usersetting (user, program)
                                VALUES ($u, $p)));
            };
            if ($@){$self->printtrace("Datenbankfehler: ".$@."\n")}    
        }
    }
}

sub _programme_oder_user_auslesen{
    my ($self, $u_or_p) = @_;
    
    my $dbh = $self->dbh();
    
    my $tab = 'statik_'.$u_or_p;
    
    my @recs;
    my $sth = $dbh->prepare(qq(SELECT $u_or_p FROM $tab));
    $sth->execute();
    while (my ($rec) = $sth->fetchrow_array()){
        push @recs, $rec
    }
    
    return \@recs;
}

sub write_ral_act{
    my ($self, $progact, $hexastr) = @_;
    
    my $dbh = $self->dbh();
    my $user = $self->user();
    
    $dbh->do(qq(UPDATE statik_usersetting a, statik_user b, statik_program c
                SET     a.hexastr = '$hexastr'
                WHERE   a.user = b.user
                AND     a.program = c.program
                AND     b.name = '$user'
                AND     c.name = '$progact'
            ));
}

sub write_settings{
    my ($self, $progact, $e_vals_ref) = @_;
    
    my %e_vals = %$e_vals_ref;
    my (@recs);
    for my $k (keys %e_vals){
        next if ($k eq 'hexastr');
        push @recs,  ('a.'.$k.' = '."'".$e_vals{$k}."'")
    }
    my $setstr = join ",", @recs;
    my $user = $self->user();
    
    my $dbh = $self->dbh();
    
    $dbh->do(qq(
        UPDATE statik_usersetting a, statik_user b, statik_program c
        SET $setstr
        WHERE a.user = b.user
        AND a.program = c.program
        AND b.name = '$user'
        AND c.name = '$progact'
        ));
}

sub canv2pdf{
    my ($self) = @_;
    
    my $tmp_ps = File::Temp->new(
        TEMPLATE    => 'psXXXXXX',
        SUFFIX      => '.ps',
        UNLINK      => 0,
        TMPDIR      => 1,
    );
    my $tmp_ps_p = File::Spec->catfile($tmp_ps->filename());
    
    $self->canv()->postscript(  -file => $tmp_ps_p,
                                - pageheight => '297m',
                                - pagey => '148m',
                                - pageanchor => "center"
                                 );
    
    my $tmp_pdf = PDF::convert_pdf_version::convert2version13($tmp_ps_p);
    
    system ('start', $tmp_pdf);
    my $summy;
    
}

1;