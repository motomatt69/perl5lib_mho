#!/usr/bin/perl -w
use strict;

#use CGI::Carp qw(fatalsToBrowser);
use OOP::HTMLprint;

my $html = HTMLprint -> new();
$html-> Anfang("Ganz elegantes Perl");
$html->Titel("Ganz elegantes Perl");
$html->Text("Popeliges HTML, aber sehr modern programmiert!");
$html->Ende();





