#!/usr/bin/perl -w
use strict;
{
    print "arrayzeugs:______________\n";
    my @dwarfs= qw ( Happy Sleepy Grumpy Dopey Sneezy Bashful);
    my @deadlysins = qw (Gluttony Sloth Anger Envy Lust Greed Pride);
    $dwarfs[7]="Funky";
    $deadlysins[7]="Incompentence";
    
    
    foreach my $i (0..6) {
        print $dwarfs[$i], " was accused of ", $deadlysins[$i],"\n"
    }
    
    print $dwarfs[$#dwarfs],"\n";
    print $deadlysins[-1],"\n";
    
    my$sin_count=@deadlysins;
    print $sin_count,"\n";
    my $n = 0;
    while ($n<@dwarfs) {
        print $dwarfs[$n++], "\n"
    }
    print"___________\n";
    my ($dw1, $dw2, $dw3, $dw4, $dw5, $dw6, $leader, $dw8)=@dwarfs;
    my ($mad, $bad, $dangerous_to_know) = @deadlysins;
    print $dw1,"\n";
    print $bad,"\n";
    push @dwarfs, $dw3;
    push @dwarfs, @deadlysins;
    print @dwarfs[2,3,5],"\n";
    my $dwarfref=\@dwarfs;
    print"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW\n";
    print @{$dwarfref}[0,1,2,3,4],"\n";
    print $dwarfref->[0..4],"\n";
    
}
print"hashzeugs:___________\n";
my %sound= ('cat' => 'meow', 'dog' => 'woof', 'goldfish' => undef); 
print "The cat replied: ", $sound{'cat'}, "\n";
foreach my $key (keys %sound) {
    print "      The key $key has the value $sound{$key} \n"
}
foreach my$val (values %sound) {
    print $val. "\n"
}
while (my($nextkey,$nextval) = each %sound) {
    print "            The key $nextkey has the value $nextval}\n"
    }

print"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n";
my @row1=(1,2,3);
my @row2=(4,5,6);
my @row3=(7,8,9);
my @cols=(\@row1,\@row2,\@row3);
my $table=\@cols;




1;
