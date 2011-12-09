#!/usr/bin/perl -w
use strict;
use CDBI::Music::DBI;

#schreiben();
&lesen();

sub schreiben {
    my $i=2;
    while ($i<10){
        my $artist=$i;
        my $cd=CDBI::Music::CD->insert({
                                  cdid=>$i,
                                  artist=>$artist,
                                  title=>'October',
                                  year=>1980,
                                 });
        $i+=1;
    }
    
    print "fertig";
}

sub lesen () {
    my @cds = CDBI::Music::CD->search(year=>1980) or die ("No such cd");
    print @cds,"\n";
    print "fertig";
}