use PDF::API2;

my $pdf = PDF::API2->open('//server-daten/AUFTRAG/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/vorlagen/Lieferschein_vorlage.pdf');

my $old = PDF::API2->open('//server-daten/AUFTRAG/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/vorlagen/ue_zeichen.pdf');

my $page = $pdf->openpage(1);

$page = $pdf->importpage($old,1,$page);

$pdf->saveas('//server-daten/AUFTRAG/Auftrag/Auftrag_2009/090468_Alstom_RDK8/Zeichnungen_ALSTOM/vorlagen/Lieferschein_vorlage1.pdf');


