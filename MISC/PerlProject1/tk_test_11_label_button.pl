#!/usr/bin/perl -w
use strict;

use Tk;

#Hauptfenster setzen
my $mw = MainWindow->new;

#Textfeld setzen (Kann nur Text anzeigen)
my $text=$mw->Label(-text=> "Bitte geben Sie Ihren Namen ein  : ",
                    -height => '5', #Größe festlegen
                    -width => '40');
$text->pack(-side=>'left',
            -anchor=>'e');

#Texteingabefenster (Kann was entgegennehmen (z.B. Text)
my $eingabe = $mw->Entry();
$eingabe->pack(-side => 'left');

#Schalter setzen mit sub

my $cmd1 = $mw->Button( -text => "Ok",
                       -height => '1',
                       -width=> '4',
                        -command => sub { \&eingabebearbeiten();},
                        -background => 'green',); #auszuführendes sub
$cmd1->pack(); #pack = Geometriemanager 

#Noch ein Schalter mit Zeitanzeige
$_ = localtime(time);
my $cmd2 = $mw->Button(-textvariable => \$_,
                       -command => sub { $_ = localtime(time) },
                       -background => 'white'); #Hintergrundfarbe ;Zur Wahl stehen folgende Farben:\n"
                                                            #print "black (schwarz), maroon (dunkelbraun),\n"
                                                            #print "green (gruen), 
                                                            #print "navy (dunkelbraun), purple (violett),\n"
                                                            #print " gray (grau),\n"
                                                            #print " red (rot),\n"
                                                            #print " yellow (gelb),\n"
                                                            #print "blue (blau), pink (pink),\n"
                                                            #print " white (weiss),\n"
                                                           
$cmd2->pack(-side=>'top');

#Schalter setzen mit sub

my $cmd3 = $mw->Button( -text => "Aufhören",
                        -command => sub { print "Zurück in der Konsole\n"; exit 0 ;},
                        -background => 'red',); #auszuführendes sub
$cmd3->pack(-side=>'right'); #pack = Geometriemanager 

#Nachrichten des Hauptfensters verarbeiten 
MainLoop;

sub eingabebearbeiten {
    my $popup = $mw->Toplevel;  #child Fenster zu main window
    $popup->Label(-text=> "Hallo " . $eingabe->get )->pack(-side => 'top');  #Text im childfenster anzeigen
    $popup->Button (-text=> "Zumachen", 
                    -command => [ $popup => 'destroy'],
                    -background => 'yellow')->pack(-side=>'bottom'); #childfenster schliessen
    $eingabe->delete(0,100); #Löscht den Inhalt von entry ab Zeile 0-100
}
