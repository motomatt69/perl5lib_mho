#!c:\perl\bin\perl -w

$cel = 0;
$fahr = 0;

print 'Geben Sie die Celsius ein: ';
chomp ($cel = <STDIN>);
$fahr = $cel * 9 / 5 + 32;
print "$cel Grad Celsius entsprechen :";
printf("%d Grad Fahreinheit \n", $fahr);
