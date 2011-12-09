#!/usr/bin/perl -w
use strict;

print "geben Sie den Titel Ihrer Webseite ein: ";
chomp (my$title=<STDIN>);

my ($farbe,$in,$bgcolor,$textcolor);
foreach $farbe ('Hintergrund','Text') {
    while () {
        print "Geben Sie die ${ farbe} ein (? zeigt Auswahl an): ";
        chomp($in = <STDIN>);
        $in = lc $in;
        
        if ($in eq '?') {
            print "\nZur Wahl stehen folgende Farben:\n";
            print "black (schwarz), maroon (dunkelbraun),\n";
            print "green (gruen), olive (olivgruen),\n";
            print "navy (dunkelbraun), purple (violett),\n";
            print "teal (blaugruen), gray (grau),\n";
            print "silver (silbergrau), red (rot),\n";
            print "lime (hellgruen), yellow (gelb),\n";
            print "blue (blau), fuchsia (pink),\n";
            print "aqua (hellblau), white (weiss),\n";
            print "oder Return fuer keine farbe\n\n";
            next;            
        }elsif 
            ($in eq ' ' or $in eq 'black' or $in eq 'maroon' or $in eq 'green' or $in eq 'olive' or $in eq 'navy' or $in eq 'purple' or
             $in eq 'teal' or $in eq 'gray' or $in eq 'silver' or $in eq 'red' or $in eq 'lime' or $in eq 'yellow' or $in eq 'blue' or
             $in eq 'fuchsia' or $in eq 'aqua' or $in eq 'white') {last}
        else {
            print "Das ist kein gueltiger Farbname.\n";
        }    
    }    

    if ($farbe eq 'Hintergrund') {
        $bgcolor = $in;
    }else {
        $textcolor = $in;
    }
}

print "Geben Sie eine Ueberschrift ein: ";
chomp (my$head = <STDIN>);

print "Geben Sie Ihre email Adresse ein: ";
chomp (my$email = <STDIN>);

print 'x' x 30;

print "\n<HTML>\n<HEAD>\n<TITLE>$title</TITLE>\n";
print "</HEAD>\n<BODY";

if ($bgcolor ne '') {print" BGCOLOR=$bgcolor"}
if ($textcolor ne '') {print" TEXT=$textcolor"}
print ">\n";
print "<H1>$head</H1>\n<P>";

while (<>) {
    if ($_ eq "\n") {
        print "<p>\n";
    } else {
        print $_;
    }
}

print qq(<HR>\n<ADDRESS><A HREF="mailto:$email</A></ADDRESS>\n);
print "</BODY>\n</HTML>\n";