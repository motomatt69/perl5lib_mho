#!/usr/bin/perl -w
use strict;

#use lib '//server-perl/perl5lib_dev';
#use lib 'F:/PERL5LIB';

use DesignPatterns::MVC;
use Tk;

my $obj = DesignPatterns::MVC->new(
    mainwindow  => MainWindow->new(),
    
    controler   => {USE             => 'Controler',
                    METHODS         => [qw()],
                    ARGS            => {},
                    },
    
    model       => {USE             => 'Model',
                    METHODS         => [qw(daten slow)],
                    ARGS            => {},
                    },
    
    view        => {USE             => 'View',
                    METHODS         => [qw( dirselect
                                            drucker
                                            format
                                            tablematrix
                                            lesen
                                            drucken
                                            ende
                                            druckername
                                            formatname
                                            formatoptions
                                            dateien
                                            slow)],
                    ARGS            => {},
                    STRATEGY        => {Controler =>
                                        [qw(lesen
                                            drucken
                                            beenden)]},
                    }
    
);

MainLoop;

package Controler;
use base 'DesignPatterns::MVC::Controler';

sub new {
    my ($class, %args) = @_;
    return bless {%args}, $class;
}

sub lesen {
    my ($self, $files_ref) = @_;
    
    $self->model->read_dir($files_ref);
    return;
}

sub drucken {
    my ($self, $zeilen_ref, $prn, $format, $slow) = @_;
    
    $self->model->drucken($zeilen_ref, $prn, $format, $slow);
    return
}

sub beenden {
    my ($self) = @_;
    exit;
}

package Model;
use base 'DesignPatterns::MVC::Model';
use PDF::API2;
use CAM::PDF;
use File::Basename;
#use Net::Printer;
use File::Spec;
use Time::HiRes qw(sleep);
use DB::Archiv;

sub new {
    my ($class, %args) = @_;
    return bless {%args}, $class;
}

sub read_dir {
    my ($self, $files_ref) = @_;
    
    my $daten_ref = [];
    my $dpmm = 72 / 25.4;

    for my $file (sort @$files_ref) {
        my ($filename) = fileparse($file); 
        
        my @daten = ($filename);
        my $seiten; my $rotate = 0; my $dx; my $dy; 
        my $pdf = CAM::PDF->new($file);
        if (ref $pdf ne 'CAM::PDF') {
            my $pdf2 = PDF::API2->open($file);
            
            
            if (ref $pdf2 ne 'PDF::API2') {
                print "Fehler bei $file\n";
                
                $dx = '?', $dy = '?', $seiten = '?', $rotate = '?';
            }
            else {
                my $page = $pdf2->openpage(1);
            
                my ($xlu, $ylu, $xro, $yro) = $page->get_mediabox();
                $dx = abs($xro - $xlu); $dy = abs($yro - $ylu);
                $dx = int($dx / $dpmm); $dy = int($dy / $dpmm);
            
                $seiten = $pdf2->pages();
                $rotate = '?';
                
                $pdf2->end();
            }
        }
        else {
            my $seiten = $pdf->numPages();
        
            my $page = $pdf->getPage(1);
        
            (undef, undef, $dx, $dy) = $pdf->getPageDimensions(1);
            $dx = int($dx / $dpmm); $dy = int($dy / $dpmm);
        
        
            while ($page) {
                $rotate = $pdf->getValue($page->{Rotate});
                if (defined $rotate) {
                    last;
                }
                my $parent = $page->{Parent};
                $page = $parent && $pdf->getValue($parent);
            }
        }
        push @daten, ($dx, $dy, $rotate, $seiten, 1);
        push @$daten_ref, \@daten;
    }
    $self->set_daten($daten_ref);
    $self->notify('GELESEN');
}

sub drucken {
    my ($self, $data_ref, $prn, $format, $slow) = @_;
    my $dpmm = 72 / 25.4;
    
    @$data_ref = sort { $a->[0] cmp $b->[0] } @$data_ref;
    
    my $form = DB::Archiv::zng_format->retrieve($format);
    my $fx = $form->zng_format_l();
    my $fy = $form->zng_format_b();
    
    if ($prn eq 'kip') {
        my $spooldir = File::Spec->catdir('//', $prn, 'spool');
        
        my $gs = $ENV{GSC};
        my $format = '"%s" -dSAFER -dNOPAUSE -dQUIET -dBATCH ' .
             '-dDEVICEWIDTHPOINTS=%d -dDEVICEHEIGHTPOINTS=%d ' .
             '-dPDFFitPage ' .
             '-sDEVICE=ps2write -sOutputFile="%s" "%s"';


        for my $data (@$data_ref) {
            my ($f, $x, $y, $d) = @$data;
            next if (!$d);
            
            if ($y < $fy) {
                my $scale = ($fy / $y > $fx / $x) ? $fy / $y : $fx / $x;
                if ($y * $scale > 841) { $scale = $fy / $y; }
                $y *= $scale;
                $x *= $scale;
#                print "$x, $y\n";
            }
            
            my (undef, undef, $b) = File::Spec->splitpath($f);
            $b =~ s/.pdf$/.ps/i;
            my $out_file = File::Spec->catfile($spooldir, $b);
            
            my $cmd = sprintf   $format,
                                $gs,
                                $x * $dpmm, $y * $dpmm,
                                $out_file,
                                $f;
                        
            
            system $cmd;
        }
    }
    else {
        my $prn_name = $prn . '/' . $format;
        my $prn3 = Net::Printer->new(printer => $prn_name,
                                     server  => 'server-perl');
    
        for my $data (@$data_ref) {
            my ($f, $x, $y, $d) = @$data;
            next if (!$d);
        
            $prn3->printfile($f);
        
            if ($slow) {
                my $size = -s $f;
                sleep $size / 200000;
            }
            else {
                sleep 1;
            }
        }
    }
}

package View;
use base 'DesignPatterns::MVC::View';
use Tk::Grid::Utils qw(gridConfig set gridMulti);
#use Tk::DirSelection;
use Tk::TableMatrix;
use DesignPatterns::Slots qw(:slot :connect);

INIT {
    PROVIDE SLOT, 'DIRECTORY_SELECTED', &neues_verzeichnis;
}

sub init {
    my ($self, %args) = @_;
    
    $self->{formatoptions} = {
        farbkopierer2   => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        kopierer2       => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        'kopierer-tb1'  => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        'kopierer-tb2'  => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        'kopierer-kb'   => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        'kopierer-kb2'  => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        'kopierer'      => [['DIN A3'   => 'A3'],
                            ['DIN A4'   => 'A4'],],
        xerox           => [['DIN A0'   => 'A0'],
                            ['A0+1'     => 'A0+1'],
                            ['A0+2'     => 'A0+2'],
                            ['DIN A1'   => 'A1'],
                            ['DIN A2'   => 'A2'],],
        kip             => [['DIN A0'   => 'A0'],],
    };
    
    my $mw = $self->mainwindow();
    
    my (undef, $fo, $fm, $fu) = gridConfig(
        
        $mw,
        {-row       => [qw(32 536v 32)],
         -col       => [qw(800v) ],
         -minsize   => 1},
        
        $mw->Frame(),
        {-row       => [qw(32)],
         -col       => [qw(160v 128 96 96)],
         -grid      => [set 0,0]},
        
        $mw->Frame(),
        {-row       => [qw(536v)],
         -col       => [qw(800v)],
         -grid      => [set 1,0]},
        
        $mw->Frame(),
        {-row       => [qw(32)],
         -col       => [qw(32v 32v 32v)],
         -grid      => [set 2,0]}
    );
    
    ($self->{dirselect}, $self->{drucker}, $self->{format}, undef,
     $self->{tablematrix},
     $self->{lesen}, $self->{drucken}, $self->{ende}) =
    
    gridMulti(
        
        $fo->DirSelection()             => {set 0, 0},
        #$fo->SelectDirectory()          => {set 0, 0},
        $fo->Optionmenu()               => {set 0, 1},
        $fo->Optionmenu()               => {set 0, 2},
        $fo->Checkbutton(-text => 'verzögern',
                         -variable => \$self->{slow},
                         )              => {set 0, 3},
        
        $fm->Scrolled('TableMatrix')    => {set 0, 0},
        
        $fu->Button()                   => {set 0, 0},
        $fu->Button()                   => {set 0, 1},
        $fu->Button()                   => {set 0, 2},
    );
    
    $self->{dirselect}->configure(-text => 'Verzeichnis');
    
    my $tm = $self->get_tablematrix();
    $tm->configure(
        -colstretchmode     => 'unset',
        -cols               => 6,
        -titlerows          => 2,
        -roworigin          => -1,
        -variable           => {
            '-1,0'  => 'Datei',
            '-1,1'  => 'Größe',
            '-1,3'  => 'Drehung',
            '-1,4'  => 'Seiten',
            '-1,5'  => 'Drucken',
            '0,1'   => 'x',
            '0,2'   => 'y',
        }
    );
    
    $tm->spans(
        '-1,1'  => '0,1',
    );
    
    $tm->colWidth(
        1   => -50,
        2   => -50,
        3   => -50,
        4   => -50,
        5   => -50, 
    );
    
    my %images = define_bitmaps($mw);
    
    $tm->tagConfigure('checkbt0', -image => $images{checkbutton0});
    $tm->tagConfigure('checkbt1', -image => $images{checkbutton1});
    $tm->tagConfigure('ro', -state => 'disabled');
    $tm->tagCol('ro',0,1,2,3,4,5);
    $tm->tagCell('checkbt0', '0,5');
    $tm->tagRaise('title', 'checkbt0');
    $tm->tagRaise('title', 'checkbt1');
    
    $tm->bind(
        '<1>', sub {
            my ($w) = @_;
            my $Ev = $w->XEvent;
            my ($x, $y) = ($Ev->x, $Ev->y);
            my $rc = $w->index("\@$x,$y");
            my ($r, $c) = split ',', $rc;
            
            return if ($c != 5);
            my $rows = $w->cget('-rows') - 2;
            return if ($r > $rows);
            
            $rc = '0,5' if ($r <= 0);    
            
            my $ref = $w->cget('-variable');
            $ref->{$rc} = (! $ref->{$rc});
            my $tag = ($ref->{$rc}) ? 'checkbt1' : 'checkbt0';
            $w->tagCell($tag, $rc);
            
            if ($r <= 0) {
                for $r (1 .. $rows) {
                    $w->tagCell($tag, "$r,5");
                    $ref->{"$r,5"} = $ref->{$rc};
                }
            }
        }
    );
    
    $self->{format}->configure(
        -command => sub {
            $self->set_formatname(shift);
        }
    );
    
    $self->{drucker}->configure(
        -options    => [['Vorzimmer'        => 'farbkopierer2'],
                        ['Vertrieb'         => 'kopierer2'],
                        ['TB erster Stock'  => 'kopierer-tb1'],
                        ['TB zweiter Stock' => 'kopierer-tb2'],
                        ['Zentrale'         => 'kopierer-kb'],
                        ['Kaufm. Büro'      => 'kopierer-kb2'],
                        ['AV'               => 'kopierer'],
                        ['Plotter KIP'      => 'kip'],
                        ['Plotter Xerox'    => 'xerox'],
                        ],
        -command    => sub {
            my $dr = shift;
            $self->set_druckername($dr);
            my $opt = $self->get_formatoptions();
            $opt = $opt->{$dr};
            $self->get_format->configure(
                -options    => $opt
            );
        }
    );
    
    $self->{lesen}->configure(
        -text       => 'lesen',
        -command    => sub {
            my @files = grep { m!\.(pdf)$!i }
                        $self->get_dirselect->readDirectory('*.*');
            my $table = $self->get_tablematrix->cget('-variable');
            $self->lesen_Controler(\@files);
            $self->set_dateien(\@files);
            return;
            },
    );
    
    $self->{drucken}->configure(
        -text       => 'drucken',
        -command    => sub {
            my @zeilen;
            my $var = $tm->cget('-variable');
            my $rows = $tm->cget('-rows') - 2;
            
            for my $r (1 .. $rows) {
                push @zeilen, [$self->get_dateien->[$r-1],
                               @$var{"$r,1", "$r,2", "$r,5"}];
            }
            
            $self->drucken_Controler(\@zeilen,
                                     $self->get_druckername(),
                                     $self->get_formatname(),
                                     $self->get_slow());
        }
    );
    
    $self->{ende}->configure(
        -text       => 'beenden',
        -command    => sub {$self->beenden_Controler();}
    );
    
    CONNECT $self->{dirselect}, SIGNAL, 'DIRECTORY_SELECTED',
            $self,              SLOT,   'DIRECTORY_SELECTED';
    return;
}
sub neues_verzeichnis {
    my $self = shift;
    my $tm = $self->get_tablematrix();
    my $table_ref = $tm->cget('-variable');
    
    %$table_ref = map {("-1,$_" => $table_ref->{"-1,$_"},
                        "0,$_"  => $table_ref->{"0,$_"})} (0 .. 5);
    
    $table_ref->{'0,5'} = 0;
    $tm->tagCell('checkbt0','0,5');
    
    $tm->configure(-rows => 2);
    
    return;
}
sub GELESEN {
    my ($self, $notifier) = @_;
    
    my $tm = $self->get_tablematrix();
    
    my $daten_ref = $notifier->get_daten();
    my $table_ref = $tm->cget('-variable');
    
    my $zeilen = @$daten_ref;
    $tm->configure(-rows => $zeilen + 2);
    
    %$table_ref = map {("-1,$_" => $table_ref->{"-1,$_"},
                        "0,$_"  => $table_ref->{"0,$_"})} (0 .. 5);
    
    my $row = 1;
    for my $zeilen_ref (@$daten_ref) {
        for my $col (0 .. 5) {
            $table_ref->{"$row,$col"} = $zeilen_ref->[$col];
        }
        $tm->tagCell('checkbt1', "$row,5");
        $row++;
    }
    
    if ($row == 1) {
        #$row++;
        $table_ref->{'0,5'} = 0;
        $tm->tagCell('checkbt0', '0,5');
    }
    else {
        $table_ref->{'0,5'} = 1;
        $tm->tagCell('checkbt1', '0,5');
    }
    $tm->update();
}

sub define_bitmaps
{
	my ($w) = @_;

my $cbutton0 =
'
/* XPM */
static char * xpm[] = {
"9 8 3 1",
" 	c None",
"@	c #B8B8B8",
"+	c #555555",
"+++++++++",
"++++++++@",
"++     @@",
"++     @@",
"++     @@",
"++     @@",
"++@@@@@@@",
"+@@@@@@@@"};
};
';

my $cbutton1 =
'
/* XPM */
static char * xpm[] = {
"9 8 4 1",
" 	c None",
"@	c #B8B8B8",
"+	c #555555",
".	c #FF0000",
"+++++++++",
"++++++++@",
"++.....@@",
"++.....@@",
"++.....@@",
"++.....@@",
"++@@@@@@@",
"+@@@@@@@@"};
};
';

	my %images;
	$images{checkbutton0} = $w->Pixmap('cbutton0', -data => $cbutton0);
	$images{checkbutton1} = $w->Pixmap('cbutton1', -data => $cbutton1);
	%images;
}

