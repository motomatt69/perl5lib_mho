#!/usr/bin/perl -w
use strict;
use File::Spec;
use File::Slurp;
use RDK8FT::DB::RDK8FTP;

my $cdbh = RDK8FT::DB::RDK8FTP->new();

#my @dirs = qw(c: dummy);
#my $f = 'favdat.txt';
#
#my $p = File::Spec->catfile( @dirs, $f);
#
#my @lines = read_file($p);
#my @zngs = sort {$a cmp $b} (map {$_ =~ m/(\d{5}_\d{4}_\d{2})/} @lines);
#
#for my $zng (@zngs){
#    print "$zng   ";
#    my ($znr, $ind) = $zng =~ m/(\d{5}_\d{4})_(\d{2})/;
#    $znr =~ s/_/-/g;
#    my ($zeichnung )= $cdbh->zeichnung->search(zeichnungsnummer => $znr);
#    my $znr_id = $zeichnung->zeichnung_id();
#    
#    my ($zeichnungsindex) = $cdbh->zeichnungsindex->search({zeichnung => $znr_id,
#                                                          indexnr => $ind});
#    if ($zeichnungsindex){
#        my $znrind_id = $zeichnungsindex->zeichnungsindex_id();
#        
#        my $zngind2zngstat = $cdbh->zeichnungsindex2zngstatus->find_or_create(zeichnungsindex => $znrind_id);
#        $zngind2zngstat->stl(1);
#        $zngind2zngstat->et(1);
#        $zngind2zngstat->fav(1);
#        
#        $zngind2zngstat->update();
#        
#        print "$zng $znrind_id\n";
#    }
#    else{
#        print "$zng nicht in DB\n";
#    }
#}
#
#
#
#my $dummy;




#my $p ='T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*\?????_????_??.pdf';
#    my @fs1 = glob ($p); #files
#
#print "teil1\n";
#
#my $p1 = 'T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\*\*\?????_????_??.pdf';
#    
#my @fs2 = glob ($p1);
#  
#push @fs1, @fs2;
#
#map {print $_,"\n"} @fs1;
#
#my $dummy;