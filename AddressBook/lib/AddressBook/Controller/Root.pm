package AddressBook::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';


sub index :Private {};

sub default : Private {
    my ( $self, $c ) = @_;

    $c->response->status('404');
    $c->stash->{template} = 'not_found.tt2';
}


sub end : ActionClass('RenderView') {}


1;
