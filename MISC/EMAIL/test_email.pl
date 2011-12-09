use strict;
use warnings;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
#use Email::Simple::Creator;
use Email::Sender::Transport::SMTP;

my $emailstr = "hallole\n";

my $transport = Email::Sender::Transport::SMTP->new({
                                                    host => 'server-email.wendeler.de',
                                                    port => 25,
                                                    });

my $email = Email::Simple->create(header => [
                                            To => 'hofmann@wendeler.de',
                                            From => '"" <niemand@keiner.de>',
                                            Subject => 'Protokoll',
                                            ],
                                            body => $emailstr,
                                  );
                              
sendmail ($email, {transport => $transport });

