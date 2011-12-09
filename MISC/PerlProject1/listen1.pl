#!/usr/bin/perl -w
use strict;

my @liste;
push @liste,1;
print @liste,"\n";
push @liste,(2,3,4);
print @liste,"\n";
$liste[5]="foo";
shift @liste;
print @liste,"\n";
print"___________________________\n";
@   liste =();
splice (@liste,$#liste+1,0,1);
print @liste,"\n";
splice(@liste,$#liste+1,0,(2,3,4));
print @liste,"\n";
splice(@liste,5,0,"foo");
splice(@liste,0,1);
print @liste,"\n";
