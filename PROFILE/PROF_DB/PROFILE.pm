package PROFILE::PROF_DB::PROFILE;
use strict;
use base 'DB::Utils';

use PROFILE::PROF_DB::PROFILE::hea_dat;
sub hea_dat { return (caller 0)[3]};
use PROFILE::PROF_DB::PROFILE::prof_main;
sub prof_main { return (caller 0)[3]};
use PROFILE::PROF_DB::PROFILE::ral;
sub ral { return (caller 0)[3]};

#sub new {
#    my ($class) = @_;
#    
#    my $self = bless {
#        dbh => PROFILE::DB::PROFILE::base->db_Main(),
#    }, $class;
#    
#    return $self;
#}
#
#sub dbh {
#    my ($self) = @_;
#    return $self->{dbh} if ref $self;
#    return PROFILE::DB::TAB::base->db_Main();
#}

1;
