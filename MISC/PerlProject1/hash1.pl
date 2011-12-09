#!/usr/bin/perl -w
use strict;
my%paare=(
          matthias=>1969,
          annette=>1970,
          yannick=>1999,
          lina=>2002);
print (%paare,"\n");
print "$paare{matthias} \n";
my @schluessel= keys %paare;
print (@schluessel,"\n");
my @werte = values %paare;
print (@werte,"\n");
print"____________________________________\n";
while((my$schluessel, my$wert) = each %paare) {
    print "$schluessel => $wert\n";
}
print"____________________________________\n";

foreach my$schluessel (sort keys %paare) {
    print ("$schluessel => $paare{$schluessel},\n");
}
