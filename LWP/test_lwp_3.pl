#!/usr/bin/perl -w
use strict;

use HTTP::Status;
use HTTP::Response;
use HTML::Parse;
use LWP::UserAgent;
use URI::URL;
#use vars qw($opt_h $opt_r $opt_H $opt_d $opt_p);
#use Getopt::Std;


my @urls = ('http://www.wendeler.de/',
                 'http://www.t-online.de'
                 );

for my $url (@urls){
    my ($code, $desc, $header, $body) = simple_get($url);
    
    print "########################################\n";
    print "Address: $url\n\n";
    print "links:\n";
    print_hyperlinks($body, $url);
    
    
    
    
    #print "$code  $desc\n";
    #print "Header: $header\n";
    #print "Body: $body\n";
    print "\n\n\n";
}

sub simple_get{
    my ($address) = @_;
    
    my $ua = LWP::UserAgent->new();
    
    $ua->agent("hcat/1.0");
    
    my $request = HTTP::Request->new('GET', $address);
    my $response = $ua->request($request);
    
    my $code = $response->code();
    my $desc = HTTP::Status::status_message($code);
    my $type = $response->content_type();
    my $headers = $response->headers_as_string();
    
    my $body = $response->content();
    $body = $response->error_as_HTML if ($response->is_error);
    
    return ($code, $desc, $headers, $body);
}

sub print_hyperlinks{
    my ($body, $url) = @_;
    
    my $parsed_html = HTML::Parse::parse_html($body);
    my @extract_links = @{$parsed_html->extract_links(qw/a/)};
    for my $i (@extract_links){
        my $link = $i->[0];
        my $absolute_link = globalize_url($link, $url);
        print "$absolute_link\n";
    }
}

sub globalize_url{
    my ($partial, $model) = @_;
    
    my $url = URI::URL->new($partial, $model);
    my $globalized = $url->abs->as_string;
    
    return $globalized;
}

my $dummy;