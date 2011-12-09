#!/usr/bin/perl
use XML::Parser;

my %auftrag;

my $p1 = new XML::Parser ();

$p1->setHandlers (Start => \&anfang,
                  End   => \&ende,
                  );

$p1->parsefile ("C:/perl5lib_home/xml/phase.xml");

sub anfang {
    my ($p1, $starttag, %atts) = @_;
    
    print "<$starttag>";
    for my $key (sort keys %atts){
        print "$key: $atts{$key}\n";
        $auftrag{$key} = 1;
    }
    
}

sub ende{
    my ($p1, $endtag) = @_;
    
    print "</$endtag>\n";
}





my $dummy;