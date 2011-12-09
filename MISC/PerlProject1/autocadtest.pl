#!/usr/bin/perl -w
use strict;
#!/usr/bin/perl -w
use strict;
use Win32::OLE qw(in with);
use Win32::OLE::Const 'AutoCAD 2005';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);

$Win32::OLE::Warn = 3; #3 bedeutet Die on errors
##Name der exceldatei
#my $excelfile = 'c:\dummy\perltut.xls';

#Excel Anwendung einbinden
my $aca = Win32::OLE->GetActiveObject('Autocad.Application')
            || Win32::OLE->new('Autocad.Application','Quit');
#my $dwg = $aca->Drawing->open('c:\dummy\test1.dwg');
#$dwg->Saveas('c:\dummy\test2.dwg');
$aca->{visible}=1;

#my (@Sp,@Ep);
#@Sp = ([100, 100,0]);
#@Ep = ([500, 1000,0]);
#print @Sp;
#my $lineObj = $aca->ActiveDocument->ModelSpace->AddLine(1,5);
#

1;
$aca->close;
#my@pts = ([100, 100,0], [1000, 1000,0]);

#my @points;
#$points[0] = 10; $points[1] = 20; $points[2] = 0;
#$points[3] = 1000; $points[4] = 2000; $points[5] = 0;
#$points[6] = 10; $points[7] = 20; $points[8] = 0;
#
#my $PlineObj = $aca->->ModelSpace->AddLine(1,2,0);
#    $PlineObj->Color = 'acGreen';