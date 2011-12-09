package PPEEMS::SHOPDWG_1::m_ftpliste;
use strict;
use Spreadsheet::WriteExcel;
use Moose;

has 'ftpliste'     => (isa => 'ArrayRef', is => 'rw', required => 0);
has 'ftplistepfad' => (isa => 'ArrayRef', is => 'rw', required => 0);

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
    
    
    
    my $dummy;
    
    
}
1;