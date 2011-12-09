package BANK::DB::STRUCT;
use strict;

use BANK::DB::STRUCT::banken;
sub banken { return (caller 0)[3]};
use BANK::DB::STRUCT::buchungen;
sub buchungen { return (caller 0)[3]};
use BANK::DB::STRUCT::empf_abse;
sub empf_abse { return (caller 0)[3]};
use BANK::DB::STRUCT::kategorien;
sub kategorien { return (caller 0)[3]};
use BANK::DB::STRUCT::konten;
sub konten { return (caller 0)[3]};
use BANK::DB::STRUCT::namen;
sub namen { return (caller 0)[3]};
use BANK::DB::STRUCT::regex2unterkat;
sub regex2unterkat { return (caller 0)[3]};
use BANK::DB::STRUCT::unterkat;
sub unterkat { return (caller 0)[3]};


sub new {
    my ($class) = @_;
    
    my $self = bless {
        dbh => BANK::DB::STRUCT::Base->db_Main(),
    }, $class;
    
    return $self;
}

sub dbh {
    my ($self) = @_;
    return $self->{dbh} if ref $self;
    return BANK::DB::STRUCT::Base->db_Main();
}

1;
