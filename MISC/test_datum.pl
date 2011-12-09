#!/usr/bin/perl -w
use strict;

use Date::Calc qw(Delta_Days Today_and_Now Gmtime);
use Time::localtime;

#my $yyyy = localtime->year()+ 1900;
#my $mm = localtime->mon() + 1;
#$mm = sprintf "%02d", $mm;

#my $dd = localtime->mday();
#$dd = sprintf "%02d", $dd;

#my $date =  (sprintf "%02d", localtime->mday())
#            .'.'
#            .(sprintf "%02d", localtime->mon() + 1)
#            .'.'
#            .(sprintf "%4d", localtime->year() + 1900);

my $date1 = '2010-09-14';
my ($y1, $m1, $d1) = $date1 =~ m/(\d{4})-(\d{2})-(\d{2})/;

my $date2 = 'Di 27.07.2010 15:26 +0100';
my ($d2, $m2, $y2) = $date2 =~ m/\D{2}\s(\d{2})\.(\d{2})\.(\d{4})/;

my $deltadays = Delta_Days($y1, $m1, $d1, $y2, $m2, $d2);





my ($y, $mo, $d, $h, $mi, $s) = Today_and_Now(localtime());
my $ts = sprintf "%02d-%02d-%02d %02d:%02d:%02d", $y, $mo, $d, $h, $mi, $s ;                                         
                                              
my $dummy;                                             