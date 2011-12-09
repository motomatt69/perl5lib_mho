#!/usr/bin/perl -w
use strict;

use WWW::Mechanize;

my $ua = WWW::Mechanize->new();
$ua->get("http://server-perl.wendeler.de:631/printers");

my @link1 = $ua->find_all_links(url_regex => qr!/printers/!i);
my %printers = map{$_->text => $_} @link1;

my $pn = "kopierer2";
my $p_link = $printers{$pn};
my $url = $p_link->url;
$ua->get($url);
#my  (@p_link) = $ua->find_all_links(url_regex => qr/$pn/i);
                                  # text => "Drucker konfigurieren");
#map{print "url: ", $_->url, "\n";
#    print "text: ", $_->text, "\n"} $p_link;

#my $p_url = $p_link->url;
#$ua->follow_link(url_regex => qr/$pn/);
#my @sumits = $ua->find_all_submits();


#my @links = $ua->links();
#map{print "url: ", $_->url, "\n";
#    print "text: ", $_->text, "\n"} @links;

my $dummy;



