#!/usr/bin/perl -w
use strict;
use warnings;

use HTTP::DownloadLimit;

my $url = 'http://www.ihnen-aurich.de/fileadmin/pdf/WMM-prospekt-web-de.pdf';   

   my $obj = HTTP::DownloadLimit->new
   (
       FILE_NAME => $url,
       #REMOVE_FILE => 1,
       #TYPE_ALLOW => [qw/mp3 avi jpg xls/],
       FILE_NAME => "c:\\",
       #DEBUG => 1
   );

   $obj->Download;
   
   my $dummy;


