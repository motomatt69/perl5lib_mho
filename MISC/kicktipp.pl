use strict;
use warnings;
use WWW::Mechanize;

my $bro = WWW::Mechanize->new();

$bro->get("http://www.kicktipp.de");
#my @inputs = $bro->find_all_inputs(name => 'username');
$bro->field('username', 'matth.hofmann@googlemail.com');
$bro->field('password', 'mho01');
$bro->click('submitbutton');
#$bro->reload;
#print "Status: ", $bro->response->status_line(), "\n";
$bro->follow_link(text => 'bloodytackling');
$bro->follow_link(url_regex => qr/tippabgabe/);



#$bro->field('tippspieltagIndex', 1);
#$bro->click('submitbutton');

$bro->dump_all;
my @inputs = $bro->find_all_inputs();

my @links = $bro->find_all_links();
for my $l (@links){
   print $l->[0],"\n"; 
    
}





my $dummy;
          
          