package MyApp::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [MyApp->path_to('root', 'src')],
    TIMER => 0,
    WRAPPER => 'wrapper.tt2',
);



1;
