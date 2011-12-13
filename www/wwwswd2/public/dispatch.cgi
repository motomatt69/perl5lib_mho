#!C:\Perl64\bin\perl.exe
use Plack::Runner;
use Dancer ':syntax';
my $psgi = path(dirname(__FILE__), '..', 'wwwswd2.pl');
Plack::Runner->run($psgi);
