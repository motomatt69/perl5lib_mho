#!/usr/bin/perl -w
use strict;

use LWP::Simple;
use HTML::Parse;
use URI::URL;

my $address = 'http://www.baulogis.com/';
my $html = get ($address);
my $parsed_html = HTML::Parse::parse_html($html);
my @links = @{$parsed_html->extract_links}; 

for my $l (@links){
    my $link = $l->[0];
    my $url = new URI::URL $link;
    my $full_url = $url->abs($address);
    print "$full_url\n";
}
my $dummy;
