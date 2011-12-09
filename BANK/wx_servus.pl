#!/usr/bin/perl -w
use strict;
use warnings;

package ServusWelt; 
use Wx;                                     # Wx einbinden 
use base qw(Wx::App);                       # von Wx::App ableiten  
sub OnInit {
    my $app =  shift ;
    my $frame = Wx::Frame->new(
                              undef,         # kein Eltern-Fenster
                              -1,            # Fenter id
                              'Servus Welt', # Titel
                              [-1, -1],      # Position x/y
                              [300, 400]     # Größe x/y
    );
    $app->SetTopWindow($frame);              # Fenster als oberstes bestimmen
    $frame->Show(1);                         # Fenster zeichnen
    1;
}

package main;
ServusWelt->new->MainLoop;                   # Programminstanz erzeugen und starten