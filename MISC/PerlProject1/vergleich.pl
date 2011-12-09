#!/usr/bin/perl -w

$input = ''; #Zwischenspeicher
@array1 = (); # Erstes Array
@array2 = (); # Zweites Array
@final = (); #Schnittmenge

print 'Geben Sie das erste array ein: ';
chomp ($input = <STDIN>);
@array1 = split(' ', $input);
print "Geben Sie das zweite array ein: ";
chomp ($input = <STDIN>);
@array2 = split(' ',$input);

foreach $el (@array1) {
    foreach $el2 (@array2) {
        if (defined $el2 && $el eq $el2) {
            $final[$#final+1] = $el;
            undef $el2;
            last;
        }
    }
}
print "@final\n";