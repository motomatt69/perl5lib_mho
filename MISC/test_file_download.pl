#!/usr/bin/perl -w
use strict;
use warnings;

use LWP::Simple;

my $url = 'https://www.baulogis.com/v30/download/5f5989abba3af295/zxjBGVEWCTqNYkURxFJTrwEHH4C8Etl-OhXJHpTYdCo8O7il6fFeTURFLo1Gs3E6Fgp1j1ZDc_27hQ/heute%20-1%20f%C3%BCr%20auto%20Report.xls';
    
getstore($url, "c:\\dummy\\1.xls");


   
   my $dummy;


