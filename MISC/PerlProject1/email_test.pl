#!/usr/bin/perl -w
use strict;
use Email::Sender::Simple qw (sendmail);
use Email::Simple;
use Email::Simple::Creator;

my $email = Email::Simple->create(header => [From => 'm.hofmann@kabelbw.de',
                                             To   => 'matth.hofmann@googlemail.com',
                                             Subject => 'test',
                                            ],
                                  body => 'text',
                                 );



my $header = $email->header_obj;

print $email->as_string;
sendmail($email);


my $dummy;

