#!/usr/bin/perl -w
package RDK8FT::troop::pdf_abt_nesting;
use strict;
use warnings;
use pdf::API2;
use constant mm => 25.4 / 72;

sub nesting {
    my ($class, $fnames_ref, $Savepath, $zng) = @_;
    
    my $dir = File::Spec->catdir('c:', 'dummy', '090468');
    
    my $pdf = PDF::API2->new;
    my $sbl = $zng.'_Einzelteile.pdf';
    $sbl = File::Spec->catfile($Savepath, $sbl);
    my $plako = 'swd.pdf';
    $plako = File::Spec->catfile($dir, $plako);
     
    
    my ($page, $b_blatt, $h_blatt) = NeueSeiteeinrichten($pdf);
    
    #ETZ laden
    my @etzs = @$fnames_ref;
    #my @etzs = ('102P10001_00.pdf', '102P10002_00.pdf', '102P10003_00.pdf', '102P10004_00.pdf',
    #            '102P10005_00.pdf', '102P10006_00.pdf', '102P10007_00.pdf', '102P10008_00.pdf',
    #            '102P10009_00.pdf', '102P10010_00.pdf', '102P10011_00.pdf', '102P10012_00.pdf',
    #            '102P10013_00.pdf', '102P10014_00.pdf', '102P10015_00.pdf', '102P10016_00.pdf',
    #            '102P10017_00.pdf', '102P10018_00.pdf', '102P10019_00.pdf', '102P10020_00.pdf');
           #     '102P10021_00.pdf', '102P10022_00.pdf', '102P10023_00.pdf', '102P10024_00.pdf');
    
    my ($cnt, $x, $y, $anz_page) = (1, 0, 0, 1);
    foreach my $etz (@etzs) {
        my $file = File::Spec->catfile($Savepath, $etz);
        
    #öffnen und Größe holen    
        my $old = PDF::API2->open($file);
        my $pageold = $old->openpage(1);
        my @sizes = $pageold->get_mediabox;
        foreach my $size (@sizes) {
            $size *= mm;
        }
        my $b_old = $sizes[2] - $sizes[0];
        my $h_old = $sizes[3] - $sizes[1];
    #Verkleinerungsfaktor ermitteln    
        my $fac_b = ($b_blatt / 4) / $b_old;
        my $fac_h = ($h_blatt / 4) / $h_old;
        my $fac = ($fac_b < $fac_h) ? $fac_b : $fac_h;
    #Einfügen    
        $y = 3 - $y;  #oben anfangen
        my $py = $y * ($h_blatt /mm) / 4;
        my $px = $x * ($b_blatt /mm) / 4;
        my $xo = $pdf->importPageIntoForm($old,1);
        my $gfx = $page->gfx;
        $gfx->formimage($xo, $px, $py, $fac);
    
    print " $cnt   $x    $y    $anz_page\n";
        
        $y = int ($cnt / 4);
        $x = ($cnt / 4 - $y) * 4;
        
        $cnt++;
        
        if (($cnt / 16) == (int $cnt / 16)) {
            Plankopfdrauf($pdf, $page, $plako, $b_blatt, $zng);
            $anz_page++;
            ($page, $b_blatt, $h_blatt) = NeueSeiteeinrichten($pdf);
            ($cnt, $x, $y) = (1, 0, 0);
        }
    }
    Plankopfdrauf($pdf, $page, $plako, $b_blatt, $zng);
    $pdf->saveas($sbl);
    $pdf->end;
}    
    sub NeueSeiteeinrichten{
        my ($pdf)=@_;
        
        my $page = $pdf->page(0);
        my ($b_blatt, $h_blatt) = (1189, 841);
        $page->mediabox($b_blatt /mm, $h_blatt /mm);
        #$page->cropbox(0/mm, 0/mm, 1189/mm, 841/mm);
        
        return ($page, $b_blatt, $h_blatt)
    }

sub Plankopfdrauf{
    my($pdf, $page, $plako, $b_blatt, $zng)= @_;
    
    my $HelveticaBold = $pdf->corefont('Helvetica-Bold');
    
    #Wasserzeichen
    my $kopf = PDF::API2->open($plako);
    my $pageold = $kopf->openpage(1);
    my @sizes = $pageold->get_mediabox;
    foreach my $size (@sizes) {
        $size *= mm;
    }
    my $xo = $pdf->importPageIntoForm($kopf,1);
    my $wazei = $page->gfx;
    $wazei->formimage($xo, $b_blatt /mm - $sizes[2] /mm - 15 /mm , -25 / mm, 1);
    
    #A4 Rahmen
    my $frame = $page->gfx;
    $frame->rectxy($b_blatt / mm - 175 / mm,5 / mm, $b_blatt / mm - 5 / mm, 153 / mm);
    $frame->stroke;    
    
    #Auftrag
    my $auf_txt1 = $page->gfx;
    $auf_txt1->textlabel($b_blatt / mm - 165 /mm, 120 / mm, $HelveticaBold, 40,"090468 ALSTOM RDK8",
                        -align => 'left',
                         );
    $auf_txt1->stroke;

    my $auf_txt2 = $page->gfx;
    $auf_txt2->textlabel($b_blatt / mm - 165 /mm, 100 / mm, $HelveticaBold, 35,"Fast Track",
                           -align => 'left',
                           );
    $auf_txt2->stroke;
    
    my $pge_nr = $pdf->pages;
    my $auf_txt3 = $page->gfx;
    $auf_txt3->textlabel($b_blatt / mm - 165 /mm, 70 / mm, $HelveticaBold, 35,'Einzelteilblatt '.$pge_nr.' zu',
                           -align => 'left',
                           );
    $auf_txt3->stroke;
    
    #my $Zng = '29999_15_15  Blatt ';
    my $auf_txt4 = $page->gfx;
    $auf_txt4->textlabel($b_blatt / mm - 165 /mm, 30 / mm, $HelveticaBold, 60,$zng,
                           -align => 'left',
                           );
    $auf_txt4->stroke;
}    
    
1;


