use strict;
use warnings;
use Mail::MboxParser;

my $p = "//server-email/daten/test";
my $mailfolder = File::Spec->canonpath($p);

my $parseropts = {
    enable_cache    => 1,
    enable_grep     => 1,
    #cache_file_name => 'mail/cache-file',
};
my $mb = Mail::MboxParser->new($mailfolder, 
                                decode     => 'ALL',
                                parseropts => $parseropts);

# -----------

# slurping
for my $msg ($mb->get_messages) {
    print $msg->header->{subject}, "\n";
    $msg->store_all_attachments(path => '/tmp');
}
