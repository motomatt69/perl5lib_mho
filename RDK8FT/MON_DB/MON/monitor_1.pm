package RDK8FT::MON_DB::MON::monitor_1;
use strict;
use warnings;
use base 'RDK8FT::MON_DB::MON::Base';

__PACKAGE__->table('monitor_1');

my @columns =qw(id
                position
                cube
                erection_seq
                workshopdwg_de
                actual_rev
                fabricator
                workshopdwg_fab
                manufactured_rev
                diff_rev_act_man 
                parts_state_prog
                info_bf deli_loc
                shipment
                bundle
                weight_de
                weight_prog
                diff_rev_act_bffab
                auschecken_wen
                checkout_conv_bf
                info_from_bf_wen
                deli_date_wen
                req_ready_for_disp
                conf_ready_for_disp
                ready_for_disp
                new_bun_wen
                date_of_outgoing_bf
                fab_rev_bf
                in_excel
                neu_in_mon);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;

