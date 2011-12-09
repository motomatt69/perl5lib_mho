package Lieferschein::ReadWrite;
use strict;
use Lieferschein::SQL qw(get_values);
use File::Slurp;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(read_csv write_csv);

sub read_csv {
    my ($in_file) = @_;
    my %dat;
    
    for my $zeile (read_file($in_file)) {
        if ($zeile =~ m!^080335!) { #Kopfzeile mit Schlüssel 0 versehen 
            $dat{0} = $zeile;
            next;
        }
        
        next unless ($zeile =~ m!^1;\w+.+;\d+,\d;\d{5};\d+;!); #Nur gültige HPos Zeilen 
    
        my  @daten = split ';', $zeile;
        pop @daten; #Leerzeile entfernen
    
        $daten[5] =~ s/,/./; #Beim Gewicht Komma durch Punkt ersetzen

        if (exists $dat{$daten[7]}) {
            my $daten_ref = $dat{$daten[7]};
            $daten_ref->[0]++;          #Anzahl um 1 erhöhen
            $daten_ref->[5] += $daten[5];   #Gewicht dazuaddieren
        }
        else {
            $dat{$daten[6].$daten[7]} = \@daten;
        }
    }
    return \%dat;
}

sub write_csv {
    my ($out_file, $dat_ref) = @_;
    my @ausgabe;
    for my $key (sort {$a <=> $b} keys %$dat_ref) {
        if ($key eq '0') {              #Kopfzeile 
            unshift @ausgabe, $dat_ref->{0};
            next;
        }
    
        my $daten_ref = $dat_ref->{$key};
        push @ausgabe, join ';', @$daten_ref,
                                 get_values($daten_ref->[6]),#Zusatzwerte aus DB anfügen
                                 "\n";
    }
    write_file($out_file, @ausgabe);
}

1;