#!/usr/bin/perl -w
use strict;
use Lieferschein::SQL qw(get_values);
use Lieferschein::mho;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(sql_export);


sub sql_export {
 my ($out_file, $dat_ref) = @_;
 
#Verbindung aufbauen 
my $dbh = Lieferschein::mho::connect();
print "Verbunden\n"; 
my ($cnt,$cnt1); 
    for my $key (sort {$a <=> $b} keys %$dat_ref) {
        if ($key eq '0') {              #Kopfzeile 
      #      unshift @ausgabe, $dat_ref->{0};
            next;
        }
    
        my $daten_ref = $dat_ref->{$key};
        my @Zusatzwert = get_values($daten_ref->[6]);#Zusatzwerte aus DB anfügen
        
# Abfrage vorbereiten
        my $sqlabfrag=$dbh->prepare(qq/SELECT prof FROM bte WHERE znr = ? AND hp = ?;/);
# Daten einfügen vorbereiten
        my $sqleinfueg=$dbh->prepare(qq/INSERT INTO bte (anz,prof,lae,breit,hoch,gew,znr,hp,zchn_nr_ku,bauteil_ku) VALUES
                     ("@$daten_ref[0]",   #anz
                     "@$daten_ref[1]",    #prof
                     "@$daten_ref[2]",    #lae
                     "@$daten_ref[3]",    #breit
                     "@$daten_ref[4]",    #hoch
                     "@$daten_ref[5]",    #gew
                     "@$daten_ref[6]",    #ts
                     "@$daten_ref[7]",    #hp
                     "$Zusatzwert[0]",    #zchnNrKu    
                     "$Zusatzwert[1]"     #bauteilKu
                    )/);
# Noch nicht vorhandene Datensätze einfuegen
        $sqlabfrag->execute($daten_ref->[6],$daten_ref->[7]);
        my (@val)=$sqlabfrag->fetchrow_array();
        
        if (@val) {
            $cnt++;
        }else{
            $sqleinfueg->execute;
            $cnt1++;
        }
        $sqlabfrag->finish;
        $sqleinfueg->finish;
        
    }
$dbh->disconnect();
print "Bereits vorhandene Datensätze: $cnt\n";
print "Neu eingefügte Datensätze: $cnt1\n";
print "Fertig\n";
}

1;