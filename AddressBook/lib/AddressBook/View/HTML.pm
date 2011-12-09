package AddressBook::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        AddressBook->path_to( 'root', 'src' ),
        AddressBook->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TEMPLATE_EXTENSION => '.tt2',
    TIMER        => 0,
    render_die   => 1,
});


1;

