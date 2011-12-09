#!/usr/bin/perl -w
package RDK8FT::BUNDLE::pdf_bundle;

use strict;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::File::Paths;
use PDF::API2;
use PDF::Table;
use File::Spec;

sub new {
    my ($class, $bun_nr) = @_;
    my $self = bless {}, $class;
    $self->{'nr'} = $bun_nr;
    $self->{seite_anz} = 1;
    $self->{seiten} = [];
    $self->{date} = Datum_ermitteln($self);
    pdf_erstellen($self);
}
    
sub pdf_erstellen {
    my ($self) = @_;
    #my $bun_nr = $self->{'nr'};
    my $pdf     = PDF::API2->new();
    $self->{vorlage} = PDF::API2->open('//server-daten/AUFTRAG/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/vorlagen/bundle_vorlage.pdf');
    $self->{font} = $pdf->corefont('Helvetica-Bold');
    
    my $page = $pdf->importpage($self->{vorlage}, 1);
    my $seiten = $self->{seiten};
    push @$seiten, $page;
    
    Tabelle_erstellen($self, $pdf, $page);
    
    Auftragskopf($self, $page);
    
    Bundle_Datum_Seitenzahl($self);
    
    my $pfad = RDK8FT::File::Paths->get_bundle_out_dir();
    $pfad = File::Spec->catfile($pfad , $self->{nr}.'.pdf'); 
    $pdf->saveas($pfad);
    
    @$seiten = ();
    $pdf->end();
    
#DB Eintrag
    my $datei = RDK8FT::DB::RDK8FTP::datei->find_or_create({path => $pfad,
                                                            verarbeitet => 1});
}


sub Auftragskopf{
    my($self, $page) = @_;
    
    my $auftrag1 = $page->gfx;
    $auftrag1->textlabel(65,700, $self->{font},16,"090468 ALSTOM RDK8",
                    -align => 'left',
                   );

    my $txt;
    if ($self->{cube} =~ m/BUM(F|R)/){
        $txt = "Faster Erection / Bandagenmodule";
    }
    else{
        $txt = "Fast Track";
    }
    
    my $auftrag2 = $page->gfx;
    $auftrag2->textlabel(65,680,, $self->{font},14,$txt,
                    -align => 'left',
                   );
}


sub Tabelle_erstellen{
    my ($self, $pdf, $page) = @_;
    
    my $pdftable2 = PDF::Table->new();

    my @v_bundlepos = RDK8FT::DB::RDK8FTP::v_bundlepos->search(nummer => $self->{nr},
                                                              {order_by => 'alstom_id' });
    my @tab;
    $tab[0]= ['lfd Nr','Zeichnung', 'AlstomPos', 'Cube', 'Menge [Stk]', 'Gewicht [kg]', 'Gesamt [kg]'] ;

    my $cnt = 1;
    my ($Summe_g, $Summe_stk);
    foreach my $bpos (@v_bundlepos) {
        my $znr = $bpos->zeichnungsnummer();
        my $alstom_id = $bpos->alstom_id();
        my $cube = $bpos->bezeichnung();
        $self->{cube} = $cube;
        my $stk = $bpos->menge();
        my $g = format_gewicht($bpos->gewicht());
        my $ges_g_pos = format_gewicht($stk * $g);
        
        my @zeile =  ($cnt, $znr, $alstom_id, $cube, $stk, $g, $ges_g_pos );
        push (@tab,\@zeile);
        $Summe_g += $ges_g_pos;
        $Summe_stk += $stk;
        $cnt++;
    }

    my @lastzeile = ('','','','Summe:',"$Summe_stk",'',format_gewicht($Summe_g));
    push (@tab,\@lastzeile);
 
    my $tab_ref = \@tab;
    my $hdr_props_ref = {font => , $self->{font},
                     font_size => 14,
                     font_color => 'black',
                     bg_color => 'lightgray',
                     repeat   => 1};

    my $col_props_ref = [
                         {},
                         {},
                         {},
                         {},
                         {justify => 'right'},
                         {justify => 'right'},
                         {justify => 'right'}
                        ];

    $pdftable2->table($pdf,
                    $page,
                    $tab_ref,
                    x => 65,
                    w => 500,
                    start_y => 630,
                    next_y => 750,
                    start_h => 555,
                    next_h => 675,
                    padding => 5,
                    padding_right => 10,
                    background_color_odd => "lightgray",
                    header_props => $hdr_props_ref,
                    column_props => $col_props_ref,
                    new_page_func => sub { $self->new_page($pdf)},
                    );
} 

sub Bundle_Datum_Seitenzahl{
    my($self) = @_;
    
    my ($i, $seiten) = (1, $self->{seiten});
          
    foreach my $seite (@$seiten) {
        $self->{seite_akt} = $i;
        Seitenzahl_reinknallen($self, $seite);
        if ($i == 1 ) {
            $self->{dat_y} = 640;
            Datum_setzen($self, $seite);
            Bundle_setzen($self, $seite);
            $i++;
        }
        else{
            $self->{dat_y} = 760;
            Datum_setzen($self, $seite);
            Bundle_setzen($self, $seite);
            $i++;
        }
    }
}

sub Datum_ermitteln {
    my ($self) = @_;
    
    my $bun_nr = $self->{'nr'};
    
    my ($bundle) = RDK8FT::DB::RDK8FTP::bundle->search(nummer => $bun_nr);
    my $bundle_id = $bundle->bundle_id();

    my ($bun2bunstat) = RDK8FT::DB::RDK8FTP::bundle2bundlestatus->search(bundle => $bundle_id);
    my $date = $bun2bunstat->datum();

    my ($yyyy, $mm, $dd) = $date =~ m/\A (\d{4}) - (\d{2}) - (\d{2}) \D /xms;
    $date = sprintf '%s.%s.%s', $dd, $mm, $yyyy;
    
    return $date;
}        

sub Datum_setzen {
    my ($self, $page) = @_;
    
    my $dat_txt = $page -> gfx;
    $dat_txt->textlabel(565, $self->{dat_y}, $self->{font}, 14, "Datum:  $self->{date}",
                               -align => 'right',
                          );
}

sub Bundle_setzen {
    my ($self, $page) = @_;
    my $bun_txt = $page->gfx;
    
    $bun_txt->textlabel(65, $self->{dat_y}, $self->{font}, 14, "Bundle.-No:  $self->{nr}",
                            -align => 'left',
                        );
}

sub Seitenzahl_reinknallen{
    my($self, $page) = @_;
    
    my $seite_txt = $page->gfx;
    $seite_txt->textlabel(260, 20, $self->{font}, 14, "Seite: $self->{seite_akt} von $self->{seite_anz}",
                            -align => 'left',
                        );
}
sub format_gewicht {
    my ($g) = @_;
    
    return sprintf '%.3f', $g;
}
    
sub new_page {
    my ($self, $pdf) = @_;
    
    my $page;
    if ($self->{seite_anz}) {
        $page = $pdf->importpage($self->{vorlage}, 2);
    }
    else {
        $page = $pdf->importpage($self->{vorlage}, 1);
    }
    
    $self->{seite_anz}++;
    my $seiten = $self->{seiten};
    push @$seiten, $page;
    return $page;
}    
1; 