package RDK8FT::MON_DB::MON;
use strict;
use base 'DB::Utils';

use RDK8FT::MON_DB::MON::monitor;
sub monitor { return (caller 0)[3]};
use RDK8FT::MON_DB::MON::monitor_1;
sub monitor_1 { return (caller 0)[3]};
use RDK8FT::MON_DB::MON::mon_gewicht;
sub mon_gewicht { return (caller 0)[3]};


1;