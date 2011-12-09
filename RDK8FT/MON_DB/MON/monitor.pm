package RDK8FT::MON_DB::MON::monitor;
use strict;
use warnings;
use base 'RDK8FT::MON_DB::MON::Base';

__PACKAGE__->table('monitor');

my @columns = qw(   id position cube_be cube_de mont_rel erection  workshopdwg_de actual_rev  fabricator workshopdwg_fab manufactured_rev 
                    ft_del ft_mod difference_rev info_bf deli_loc date_of_deli fabricated_rev_bf difference_rev_bf
                     refodisp  new_bundle date_of_outgoing_bf info_from_bf weight_de weight_prog shipment1 bundle deli_date_baust
                     beastand gewicht color in_excel rev);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;

