package PPEEMS::SHOPDWG1::m_ftpliste;
use strict;
use Spreadsheet::WriteExcel;
use Moose;
BEGIN {extends 'Patterns::MVC::Model'};

has 'cdbh'           => (isa => 'Object',  is => 'ro', required => 0);
has 'dbh'            => (isa => 'Object',  is => 'ro', required => 0);
has 'konstrukteur'   => (isa => 'Str'     ,is => 'rw', required => 0);
has 'datum'          => (isa => 'Str'     ,is => 'rw', required => 0);
has 'ftpliste'       => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'ftplistepfad'   => (isa => 'ArrayRef', is => 'rw', required => 0);

sub BUILD{
    my ($self) = @_;
    
    $self->{cdbh} = PPEEMS::DB::PPEEMS->new();
    $self->{dbh} = $self->{cdbh}->dbh();
}

sub daten_fuer_ftpliste{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    my $dbh = $cdbh->dbh();
    
    my $konst = $self->{konstrukteur};
    my $dat   = $self->{datum};
    
    my $sth = $dbh->prepare(qq( SELECT  file
                                FROM    zz_teilzng
                                WHERE   konst LIKE ?
                                AND     date LIKE ?
                                ORDER BY file));
    $sth->execute($konst, $dat);
    my @b3dposs;
    while (my $rec = $sth->fetchrow_arrayref()){
        push @b3dposs, $rec->[0]
    }
    
    my @ftpliste;
    for my $b3dpos (@b3dposs){
        my ($ts, $pos, $bl, $rev) = $b3dpos =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})/;
        
        my $sth = $dbh->prepare(qq( SELECT  apbnr, revnr, tsnr, tsbez, apbposnr
                                    FROM    zz_v_ftp_liste
                                    WHERE   tsnr = ?
                                    AND     zngnr = ?
                                    AND     blattnr = ?
                                    AND     revnr LIKE ?));
        $sth->execute($ts, $pos, $bl, $rev);
        
        while (my @rec = $sth->fetchrow_array()){
            my $apbnr = $rec[0];
            $apbnr =~ s/\.//; #Punkt weg
            $apbnr =~ s!/!_!; #slash zu Unterstrich
            $apbnr =~ s/ //; #Leerstelle weg
            $apbnr =~ s/-/_/; #Minus zu Unterstrich
            
            my $rev = $rec[1];
            
            my $pdf_fn = $apbnr.'_'.$rev.'.pdf';
            my $dwg_fn = $apbnr.'_'.$rev.'.dwg';
            
            my $sonstigedateien = q();
            
            my $tsbez = $rec[3];
            my $apbposnr = $rec[4];
            
            my $plantitel = $tsbez.'  Pos '.$apbposnr;
            
            my $bauteilnr = $apbposnr;
            
            my $aenderungsbeschreibung = q();
            
            my $tsnr = $rec[2];
            my ($cube) = $tsnr =~ m/\d{3}(\d{3})/;
            
            my $cubennr = 'Cube '.$cube;
            
            push @ftpliste, [$pdf_fn, $dwg_fn, $sonstigedateien,
                             $plantitel, $bauteilnr, $aenderungsbeschreibung,
                             $cubennr];
        }
    }
    $self->{ftpliste} = \@ftpliste;
    return
}

sub pfad_fuer_ftp_liste{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    my $dbh = $cdbh->dbh();
    
    my $konst = $self->{konstrukteur};
    my $dat   = $self->{datum};
    
    my $sth = $dbh->prepare(qq( SELECT  vol, dirs
                                FROM    zz_teilzng
                                WHERE   konst LIKE ?
                                AND     date LIKE ?
                                GROUP BY dirs));
    $sth->execute($konst, $dat);
    $self->{ftplistepfad} = $sth->fetchrow_arrayref();
}

sub excel_liste_ausschreiben{
    my ($self) = @_;
    
    my ($v, $dirs) = ($self->{ftplistepfad}->[0], $self->{ftplistepfad}->[1].'apb');
    my $fn = 'STKW_Eems_Planuploadliste_fuer_Nachunternehmer.xls';
    my $p = File::Spec->catpath($v, $dirs, $fn);
    
    my $wb = Spreadsheet::WriteExcel->new($p);
    my $ws = $wb->add_worksheet();
    my $form1 = $wb->add_format();
    $form1->set_bold();
    $form1->set_color('blue');
    
    $ws->write(0, 0, 'Planuploadliste für den Dokumentenversand an Alstom', $form1);
    
    my $form2 = $wb->add_format();
    $form2->set_bold();
    
    $ws->write(1, 0, 'PDF-Datei', $form2);
    $ws->write(1, 1, 'DWG-Datei', $form2);
    $ws->write(1, 2, 'Sonstige Dateien', $form2);
    $ws->write(1, 3, 'Plantitel', $form2);
    $ws->write(1, 4, 'Bauteilnr.', $form2);
    $ws->write(1, 5, 'Änderungsbeschr.', $form2);
    $ws->write(1, 6, 'Cuben Nr.', $form2);
    
    $ws->write(2, 0, 'Dateinamen');
    $ws->write(2, 1, 'Dateinamen');
    $ws->write(2, 2, 'Dateinamen (durch Komma trennen');
    $ws->write(2, 3, 'Freitext');
    $ws->write(2, 4, '(8-stellig)');
    $ws->write(2, 5, 'Freitext');
    
    my @ftpliste = @{$self->{ftpliste}};
    for my $r (0..$#ftpliste){
        for my $c (0..6){
            $ws->write($r + 3, $c, $ftpliste[$r]->[$c]);
        }
    }
    
    $ws->set_column(0, 1, 27);
    $ws->set_column(2, 2, 32);
    $ws->set_column(3, 3, 30);
    $ws->set_column(4, 4, 13);
    $ws->set_column(5, 5, 19);
    $ws->set_column(6, 6, 10);
    
    $wb->close();
}
1;