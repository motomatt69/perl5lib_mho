package PPEEMS::SHOPDWG1::zng2rev_statusbits;
use strict;

use base 'Bit::Bitmask';

sub definedBits{
    return (qw/b3d2apbListe TeilZng/);
}



1;