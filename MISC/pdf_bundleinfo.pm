package RDK8FT::BUNDLE::pdf_bundleinfo;

use strict;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::File::Paths;
use pdf::API2;
use pdf::Table;
use File::Spec;
use Time::localtime;

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    #$self->{'nr'} = 1;
    $self->{seite_anz} = 1;
    $self->{seiten} = [];
    $self->{date} = Datum_ermitteln($self);
    pdf_erstellen($self);
}

sub pdf_erstellen{
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
    
    Datum_Seitenzahl($self);
    
    my $pfad = RDK8FT::File::Paths->get_bundle_out_dir();
    $pfad = File::Spec->catfile($pfad , 'bundle_info'.'.pdf'); 
    $pdf->saveas($pfad);
    
    @$seiten = ();
    $pdf->end();
    
    
}


sub Tabelle_erstellen{
    my ($self, $pdf, $page) = @_;
    
    my $pdftable2 = PDF::Table->new();

    my @v_bundleinfo = RDK8FT::DB::RDK8FTP::v_bundleinfo->retrieve_all();
    my @tab;
    $tab[0]= ['nummer','gewicht', 'laenge', 'breite', 'hoehe', 'cube', 'lieferschein'] ;
    
    my $cnt = 1;
    my ($Summe_g, $Summe_stk);
    foreach my $bun (@v_bundleinfo) {
        my $nr = $bun->nummer();
        $cnt++;
        my $g = format_gewicht($bun->gewicht());
        my $l = ($bun->laenge()) ? $bun->laenge() : '-';
        my $b = ($bun->breite()) ? $bun->breite() : '-';
        my $h = ($bun->hoehe()) ? $bun->hoehe() : '-';
                
        my $cube = $bun->cube();
        my $ls = ($bun->lieferschein()) ? $bun->lieferschein() : '-';
        
                
        my @zeile =  ($nr, $g, $l, $b, $h, $cube, $ls );
        push (@tab,\@zeile);
        $Summe_g += $g;
        $Summe_stk = $cnt;
    }
    my @lastzeile = ("$Summe_stk Stk",format_gewicht($Summe_g),'','','','','');
    push (@tab,\@lastzeile);
 
    my $tab_ref = \@tab;
    my $hdr_props_ref = {font => , $self->{font},
                     font_size => 14,
                     font_color => 'black',
                     bg_color => 'lightgray',
                     repeat   => 1};

    my $col_props_ref = [
                         {},
                         {justify => 'right'},
                         {justify => 'right'},
                         {justify => 'right'},
                         {justify => 'right'},
                         {},
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

sub Auftragskopf{
    my($self, $page) = @_;
    
    my $auftrag1 = $page->gfx;
    $auftrag1->textlabel(65,700, $self->{font},16,"090468 ALSTOM RDK8",
                    -align => 'left',
                   );

    #my $txt;
    #if ($self->{cube} =~ m/BUM(F|R)/){
    #    $txt = "Faster Erection / Bandagenmodule";
    #}
    #else{
    #    $txt = "Fast Track";
    #}
    my $txt = "Faster Erection / Bandagenmodule und Fast Track";
    
    my $auftrag2 = $page->gfx;
    $auftrag2->textlabel(65,680,, $self->{font},14,$txt,
                    -align => 'left',
                   );
}


sub Datum_Seitenzahl{
    my($self) = @_;
    
    my ($i, $seiten) = (1, $self->{seiten});
          
    foreach my $seite (@$seiten) {
        $self->{seite_akt} = $i;
        Seitenzahl_reinknallen($self, $seite);
        if ($i == 1 ) {
            $self->{dat_y} = 640;
            Datum_setzen($self, $seite);
            #Bundle_setzen($self, $seite);
            $i++;
        }
        else{
            $self->{dat_y} = 760;
            Datum_setzen($self, $seite);
            #Bundle_setzen($self, $seite);
            $i++;
        }
    }
}

sub Datum_setzen {
    my ($self, $page) = @_;
    
    my $dat_txt = $page -> gfx;
    $dat_txt->textlabel(565, $self->{dat_y}, $self->{font}, 14, "Datum:  $self->{date}",
                               -align => 'right',
                          );
}

sub Datum_ermitteln {
    my ($self) = @_;
    
    my $yyyy = localtime->year() + 1900;
    my $mm = localtime->mon()+1;
    my $dd = localtime->mday();

    my $date = sprintf '%s.%s.%s', $dd, $mm, $yyyy;
    
    return $date;
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
    
    return sprintf '%.1f', $g;
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