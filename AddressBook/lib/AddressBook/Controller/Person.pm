package AddressBook::Controller::Person;
use strict;
use warnings;
use base 'Catalyst::Controller::BindLex';

sub list :Local{
    my ($self, $c) = @_;
    my $people : Stashed = $c->model('AddressDB::People');
    $c->stash->{template} = 'Person/list.tt2';
}
1;


