#! C:\perl\bin\perl -w

$fahr = 0;
$cel = 0;

print 'Geben Sie eine Temperatur in Fahreinheit ein: ';
chomp ($fahr = <STDIN>);
$cel = ($fahr - 32) * 5 / 9;
print "$fahr Grad Fahreinheit entsprechen ";
printf("%d Grad Celsius\n", $cel);

