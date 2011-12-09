#!/usr/bin/perl -w
use strict;

my @nums=();
my $choice ="";
&getinput();

while($choice !~ /q/i) {
    $choice = &printmenu();
    SWITCH: {
        $choice =~ /^1/ && do {&printdata(); last SWITCH; };
        $choice =~ /^2/ && do {&countsum (); last SWITCH; };
        $choice =~ /^3/ && do {&maxmin(); last SWITCH; };
        $choice =~ /^4/ && do {&meanmed(); last SWITCH; };
        $choice =~ /^5/ && do {&printhist(); last SWITCH; };
    }
    
}
print "Programmende!!";





sub getinput(){
    my $count=0;
    while (<>) {
        chomp;
        $nums[$count] = $_;
        $count++;
    }
    @nums = sort { $a <=> $b } @nums
}

sub printmenu {
    my $in ="";
    print "Was moechten Sie ausgeben? (Beenden mit Q): \n";
    print "1. eine Liste der Zahlen \n";
    print "2. die Anzahl und Summe der Zahlen \n";
    print "3. die kleinste und die groesste Zahl \n";
    print "4. den Durchschnitts und den Medianwert\n";
    print "5. ein Diagramm wie oft jede Zahl vorkommt.\n";
    while() {
        print "\nIhre Auswahl  --> ";
        chomp($in = <STDIN>);
        if ($in =~ /^\d$/ || $in =~ /^q$/i) {
            return $in;
        }else{
            print "Ungueltige Eingabe. 1-5 oder Q, bitte.\n";
        }
    }
}

sub printdata {
    my $i = 1;
    my $num;
    print "die Zahlen: \n";
    foreach $num (@nums) {
        print "$num ";
        if ($i == 10) {
            print"\n";
            $i = 1;
        }else{
            $i++
        }
    }
    print "\n\n";
}
    
sub countsum {
    print "Anzahl der Zahlen: ", scalar(@nums), "\n";
    print "Summe der Zahlen: ", &sumnums(),"\n\n";
}

sub sumnums {
    my $sum = 0;
    foreach $_ (@nums){
        $sum += $_
    }
    return $sum
}

sub maxmin {
    print "Kleinste Zahl: $nums[0]\n";
    print "Groesste Zahl: $nums[ $#nums]\n\n";
}

sub meanmed {
    printf("Durchschnitt: %.2f\n", (sumnums() / scalar @nums));
    print "Median: $nums[ @nums /2]\n\n";
}

sub printhist {
    my %freq



