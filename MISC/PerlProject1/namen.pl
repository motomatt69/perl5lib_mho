#!/usr/bin/perl -w
# use strict;
$in = ''; #temp Input
%names = (); #hash Namen
$fn = ''; #temp Vorname
$ln = ''; # temp Nachname

while () {
    print 'Geben Sie eine namen ein (Vor und Nachname): ';
    chomp($in = <STDIN>);
    if ($in ne '') {
        ($fn,$ln) = split (' ',$in);
        $names{$ln} = $fn;
    }
    else {last; }
}

foreach $lastname (sort keys %names) {
    print "$lastname, $names{$lastname}\n";
}

