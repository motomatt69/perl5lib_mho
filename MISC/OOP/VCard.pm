package VCard;
use strict;

my $Objekte = 0;

sub new {
    my $Objekt = shift;
    my $Version = shift;
    my $Referenz = {};
    bless ($Referenz, $Objekt);
    $Objekte += 1;
    $Referenz->VCInit($Version);
    return ($Referenz)
}

sub VCInit{
    my $Objekt=shift;
    my $Version = shift;
    $Objekt->{Begin}="VCard";
    $Objekt->{Version}=$Version;
    $Objekt->{End}="VCard";
}

sub VCset {
    my $Objekt = shift;
    my $Schluessel = shift;
    my $Wert=shift;
    $Objekt->{$Schluessel}=$Wert;
}

sub VCget {
    my $Objekt=shift;
    my $Schluessel = shift;
    return ($Objekt->{$Schluessel});
}

sub VCsave {
  my $Objekt = shift;
  my $Datei = shift;
  open(DATEI, ">$Datei") or return(-1);
  print DATEI "BEGIN:VCARD\nVERSION:$Objekt->{VERSION}\n";
  while ((my $Schluessel, my $Wert) = each %{ $Objekt } ) {
    next if ($Schluessel eq 'BEGIN' or $Schluessel eq 'VERSION' or $Schluessel eq 'END');
    $Schluessel =~ s/_/\;/g;
    print DATEI "$Schluessel:$Wert\n";
  }
  print DATEI "END:VCARD\n";
  close(DATEI);
  return($Datei);
}

sub VCopen {
  my $Objekt = shift;
  my $Datei = shift;
  $Objekt->VCreset();
  open(DATEI, "<$Datei") or return;
  my @Zeilen = <DATEI>;
  close(DATEI);
  foreach (@Zeilen) {
   (my $Schluessel, my $Wert) = split(/:/);
    $Schluessel =~ s/\;/_/g;
    $Objekt->{$Schluessel} = $Wert;
  }
  return( %{ $Objekt } );
}

sub VCreset {
  my $Objekt = shift;
  %{ $Objekt } = ();
}


1;