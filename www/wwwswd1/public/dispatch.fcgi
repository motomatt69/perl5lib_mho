#!C:\Perl64\bin\perl.exe
use Plack::Handler::FCGI;
use Dancer ':syntax';

my $psgi = path(dirname(__FILE__), '..', 'wwwswd1.pl');
my $app = do($psgi);
my $server = Plack::Handler::FCGI->new(nproc  => 5, detach => 1);
$server->run($app);
