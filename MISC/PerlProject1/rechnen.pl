#! C:\perl\bin\perl -w

$zahl1 = 0;
$zahl2 = 0;
$erg = 0;

print 'Gebe die erste Zahl ein: ';
chomp ($zahl1 = <STDIN>);
print 'Gebe die zweite zahl ein: ';
chomp ($zahl2 = <STDIN>);
$erg = $zahl1  * $zahl2 ;
print "$zahl1 * $zahl2 = ";
printf("%d \n", $erg);

