package HTMLprint;
use strict;

sub new {
    my $Objekt = shift;
    my $Referenz = {};
    bless ($Referenz,$Objekt);
    return ($Referenz);
}

sub Anfang {
    my $Objekt = shift;
    my $Titel = shift;
    print "Content-type: text/html\n\n";
    print '<!DOCTYPE HTML PUBLIC "-//WC3//DTD HTML 4.01 Transitional//EN">', "\n";
    print "<html><head><title>$Titel</title></head><body>\n";
}

sub Titel {
  my $Objekt = shift;
  my $Ausgabetext = shift;
  print "<h1>$Ausgabetext</h1>\n";
}

sub Text {
  my $Objekt = shift;
  my $Ausgabetext = shift;
  print "<p>$Ausgabetext</p>\n";
}

sub Ende {
  my $Objekt = shift;
  print "</body></html>\n";
}


1;