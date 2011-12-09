package PROFILE::BLTR::m_reihe;
use strict;
use PROFILE::PROF_DB::PROFILE;
use DBI;
#use base 'DesignPatterns::MVC::Model';
use base qw(Class::Accessor);
__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors (qw(reihe));

sub set_profhoehen {
    my ($self) =  @_;
    my ($reihe) = $self->{reihe};
    
    my (@ids, @nhs); 
    if ($reihe ne 'BLTR'){
        $self->{cdbh} = PROFILE::PROF_DB::PROFILE->new();
        
        my $dat_tab = $self->TabelleDerProfilreihe($reihe);
        
        $self->{sqldbh} = $self->{cdbh}->dbh();
        my $sqldbh = $self->{sqldbh};
    
        my $sth = $sqldbh->prepare(qq{
            SELECT ID, nh
            FROM $dat_tab
            });
        
        $sth->execute();
                  
        while (my $val_ref = $sth->fetchrow_arrayref()){
            push @ids, $val_ref->[0];
            push @nhs, $val_ref->[1];
        }
        $sth->finish;
    }
    
    my @size;
    if ($self->{nh}) {
        @size = $self->do_profgeo
        }
    else{
        @size = (0,0,0,0,0);
    }
    
    my @rowvals = (\@ids,\@nhs,\@size);
    $self->{rowvals}=\@rowvals;
}

sub set_reihe{
    my ($self, $reihe) = @_;
    $self->{reihe} = $reihe;
}

sub set_nh{
    my ($self, $nh) = @_;
    $self->{nh} = $nh;
}

sub TabelleDerProfilreihe{
    my ($self, $reihe) = @_;
    
    my $cdbh = $self->{cdbh};
    my ($reihe_rec) = $cdbh->prof_main->search ({row_name => $reihe});
    my ($dat_tab) = $reihe_rec->row_tab_dat();
    
    return $dat_tab;
}

sub do_profgeo{
    my ($self) = @_;
    my ($reihe, $nh) =($self->{reihe}, $self->{nh});
    
    my $dat_tab = $self->TabelleDerProfilreihe($reihe);
        
    $self->{sqldbh} = $self->{cdbh}->dbh();
    my $sqldbh = $self->{sqldbh};
    
    my $sth = $sqldbh->prepare(qq{
        SELECT h, b, ts, tg, r
        FROM $dat_tab
        WHERE nh = $nh
        });
        
    $sth->execute();
        
    my @size;  
    while (my $val_ref = $sth->fetchrow_arrayref()){
        @size = ($val_ref->[0],$val_ref->[1],
                 $val_ref->[2],$val_ref->[3],
                 $val_ref->[4]);
    }
    $sth->finish;
    
    return @size;
}

sub get_rowvals{
    my ($self) = @_;
    
    return $self->{rowvals};
}
1;    
    

