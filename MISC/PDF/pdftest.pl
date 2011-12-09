use PDF::API2;

my $pdf = PDF::API2->open('R:\090477_eemshaven_zeichnungen\werkstattzeichnungen\220180\1-220180-01_01.pdf');

my $otls = $pdf->outlines;

my $dummy;

