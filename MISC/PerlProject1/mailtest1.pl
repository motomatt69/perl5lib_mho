#!/usr/bin/perl -w
use strict;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

my $transport = Email::Sender::Transport::SMTP->new({
                                                    host => 'server-email.wendeler.de',
                                                    port => 25,
                                                    });

my $email = Email::Simple->create(
                                  header => [
                                             To => '"Matthias Hofmann" <hofmann@wendeler.de>',
                                             From => '"Matthias Hofmann" <hofmann@wendeler.de>',
                                             Subject => "testmail",
                                            ],
                                  body => 'testtesttest',
                                  );
                                  
sendmail ($email, {transport => $transport });
