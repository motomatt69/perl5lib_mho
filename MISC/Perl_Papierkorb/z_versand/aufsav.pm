#!/usr/bin/perl -w
package z_versand::aufsav;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT= qw(auf_read auf_write);
our @EXPORT_OK = qw($aufakt);

use strict;

my $aufakt;
sub auf_read {
    if (-e 'aufakt') {
        open (INFILE, 'aufakt');
        my @zeile = <INFILE>;
        close INFILE;
        $aufakt=$zeile[0];
    }
return $aufakt;
}

sub auf_write {
    my ($aufakt)=@_;
    open (OUTFILE, ">aufakt"); #Aktueller Auftrag in Datei schreiben
    print OUTFILE $aufakt;
    close OUTFILE;
}

1;

