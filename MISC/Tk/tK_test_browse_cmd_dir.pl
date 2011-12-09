#!/usr/bin/perl -w
use strict;

use Tk;
use Tk::BrowseEntry;

my $mw = MainWindow->new(-title => 'Verzeichnis');

my $var;

my @paths = qw(kjfdlkagf iugi kiugig);

my $be = $mw->BrowseEntry(-label => 'Ordner waehlen',
                          -variable => \$var,
                          -browsecmd => \&ausfuehren,
                          )->pack();

$be->insert('end', @paths);
$be->bind("<Return>", \&ausfuehren);




sub ausfuehren{
    my ($be) = @_;
    
    print "nach browsecmd\n";
    my $e = $be->variable;
    
    
    
    print $var;
    my $dummy;
    
}



MainLoop();