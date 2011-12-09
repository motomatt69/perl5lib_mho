package RDK8FT::MON_DB::MON::mon_gewicht;
use strict;
use warnings;
use base 'RDK8FT::MON_DB::MON::Base';

__PACKAGE__->table('mon_gewicht');

my @columns = qw( id alstom_id g_moni g_rdk8db g_promix);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;

