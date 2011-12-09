package PROFILE::DB::PROFILE::hea_dat;
use strict;
use warnings;
use base 'PROFILE::DB::PROFILE::base';

__PACKAGE__->table('hea_dat');

my @columns = qw(ID row_name_id HEA h b ts tg r h_2c ASteg A G Iy Wy Sy i_y
                 Iz Wz Sz i_z IT Iw wmax i_z_g Npl Vpl_z Mpl_y Vpl_y
                 Mpl_z Mpl_xp Mpl_xs Mpl_w);
                 
__PACKAGE__->columns(All => @columns);

__PACKAGE__->columns(Essential => @columns);

1;