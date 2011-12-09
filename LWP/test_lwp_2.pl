#!/usr/bin/perl -w
use strict;

use LWP;
use HTML::Parse;
use HTTP::Cookies;
use URI::URL;

my $cookie_jar = HTTP::Cookies->new(
   file     => "c:\\dummy\\cookies\\cookies.lwp",
   autosave => 1,
);


my $ua = LWP::UserAgent->new();
push @{$ua->requests_redirectable}, 'POST';
$ua->cookie_jar({});


#Einloggen
my $url = 'https://www.baulogis.com/sso/verifpwd.aspx';
my $login = 'WendelerEemshaven';
my $pw = '8ffsg3';

my $res_login = $ua->post(        $url,
                             [username => $login,
                              password => $pw,],
                             );

if ($res_login->is_success){
    print "Hat geklappt\n"
    #print $response->content();
}
else{
    print $res_login->error_as_HTML;
}

my $parsed_html = parse_the_res($res_login);

my %next_links;
%next_links = links_extrahieren($url, $parsed_html, %next_links);

#Zum ThinkProject Bereich
my $res_tp = $ua->get($next_links{thinkproject});
$parsed_html = parse_the_res($res_tp);
print $res_tp->content();
%next_links = links_extrahieren($next_links{thinkproject}, $parsed_html, %next_links);

my $dummy;



sub parse_the_res{
    my ($res) = @_;
    
    my $html = $res->decoded_content();
    return HTML::Parse::parse_html($html);
}
                                   
sub links_extrahieren{
    my ($url, $parsed_html, %next_links) = @_;
    
    my @links = @{$parsed_html->extract_links};
    
    
    if (!$links[0]){
        print "Keine links\n" ;
    }
    else{
        print "\nEnthaltene links:\n";
        for my $l (@links){
            my $link = $l->[0];
            my $url = new URI::URL $link;
            my $full_url = $url->abs($url);
            print "$full_url\n";
            
            if ($full_url =~ m!https://www.baulogis.com/v30/cs/webapp/thinkproject/index.html!){
                $next_links{thinkproject} = $full_url;
            }
        }
    }
    
    return %next_links
}