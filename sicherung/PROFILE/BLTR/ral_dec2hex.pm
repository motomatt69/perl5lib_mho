package PROFILE::BLTR::ral_dec2hex;
use strict;
use PROFILE::DB::PROFILE;


sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    
    $self->{'db'} = PROFILE::DB::PROFILE->new();
    $self->get_data();
}

sub get_data{
    my ($self) = @_;
    
    my @rals = $self->{db}->ral->retrieve_all;
    foreach my $ral (@rals) {
        $self->{nr} = $ral->nr;
        print $ral->nr,"\n";
        print $ral->r,"\n";
        print $ral->g,"\n";
        print $ral->b,"\n";
        my @raldezi = ($ral->r, $ral->g, $ral->b);
        $self->do_hexastr(@raldezi);
    }
}
    

sub do_hexastr {
    my ($self, @raldezi) = @_;
    
    my %d2h = (0 => 0, 1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
                     10 => 'a', 11 => 'b', 12 => 'c', 13 => 'd', 14 => 'e', 15 => 'f'); 
    
    my $ralhexa = '#';
    foreach my $col (@raldezi) {
        my $val0 = int($col / 16);
        my $val1 = $col - ($val0 * 16);
        $ralhexa .= "$d2h{$val0}"."$d2h{$val1}";
    }
    print $ralhexa,"\n";
    my ($zeile) = $self->{db}->ral->search(nr => $self->{nr});
    $zeile->hexastr($ralhexa);
    $zeile->update;
}


1;