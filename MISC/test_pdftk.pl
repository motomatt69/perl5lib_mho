#!/usr/bin/perl -w
use strict;
use pdf::API2;
use File::RGlob;
use File::Spec;

my $glob = File::RGlob->new();
$glob->path('T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\Zeichnungen_ALSTOM\Zeichnungen\pdf\21506');
$glob->dir_exclude( sub {$_[1] =~ m/210/});
$glob->scan();
my $fn_ref = $glob->get_files();
print "geglobt\n";

my @ps = grep {$_ =~ m/\.pdf$/} @$fn_ref;
#my @ps = ('T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\FE700\21704_0312_02.pdf',
#          'T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\FE700\21704_0375_02.pdf',
#          'T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\FE700\21704_0327_01.pdf',
#          'T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\fuer_AV\FE700\21704_0317_01.pdf');

#my @ps = ('T:\Auftrag\Auftrag_2009\090468_Alstom_RDK8\Zeichnungen_ALSTOM\Zeichnungen\pdf\21506\148190_21506_0002_03_fixed.pdf');

my $pdftk = $ENV{PDFTK};
my ($cntgood, $cntevil);
for my $p (@ps){
    $cntgood++;
    print $cntgood;
    eval {
        my $old = PDF::API2->open($p);
        my $pageold = $old->openpage(1);
    };
    if ($@){
        print "\n $p \n              $@\n";
        $cntevil++;
        my ($v, $ds, $f) = File::Spec->splitpath($p);
        my $rep = $f;
        $rep =~ s/\.pdf/_fixed\.pdf/;
        $rep = File::Spec->catpath($v, $ds, $rep);
        system $pdftk, $p, 'output', $rep;
    };
}


    
    
print "Gute   $cntgood\n";
print "Böse   $cntevil\n";
my $dummy;