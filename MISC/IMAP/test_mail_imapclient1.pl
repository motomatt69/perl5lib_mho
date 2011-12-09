use strict;
use warnings;

use Mail::IMAPClient;
use WWW::Mechanize;
use LWP::Simple;

my $imap = Mail::IMAPClient->new(
        Password => 'system',
        User => '090477_baulogis',
        Server => 'server-email.wendeler.de',
    );


#my $ok = $imap->delete('INBOX.drafts');

$imap->select('INBOX');
#$imap->move('INBOX.bearbeitet', (22,28,35,36,37));
my @msg_nrs = $imap->search('UNDELETED');
map {print $_," | "} @msg_nrs;
print "\n";


my @folders = $imap->folders(); 


my $dummy;