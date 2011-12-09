#!/usr/bin/perl -w

$zahl1 = 0;
$zahl2 = 0;

print 'Geben Sie eine Bereichsgrenze ein: ';
chomp ($zahl1 = <STDIN>);
print '\n';
print 'Geben Sie die naechste Bereichsgrenze ein: ';
chomp ($zahl2 = <STDIN>);
if ($zahl1 < $zahl2) {
    @array = ($zahl1...$zahl2);
} else {
    @array = ($zahl2...$zahl1);
}
print "@array \n"

