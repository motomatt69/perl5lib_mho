#!/usr/bin/perl -w
use strict;
use Mail::Sender;

my $sender = new Mail::Sender
  {smtp => 'server-email.wendeler.de',
   from => 'hofmann@wendeler.de'
   };
 $sender->MailFile({to => 'hofmann@wendeler.de',
  subject => 'Here is the file',
  msg => "I'm sending you the list you wanted.",
  file => 'filename.txt'});
 
 print "fertig\n";


