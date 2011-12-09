#!/usr/bin/env perl
# Core Modules
use strict;
use warnings;
use utf8;
use open ':encoding(UTF-8)';
use open ':std';
use DBI;
use Benchmark;

my $t0 = Benchmark->new();
my $dbh = _sqlite_connect();

sub _sqlite_connect{

    my $dsn     = "dbi:SQLite:dbname=c:\\dummy\\temp1.sqlite";
    my $user    = "";
    my $pass    = "";
    my $options = { 
        RaiseError     => 1,
        #AutoCommit     => 1,
        sqlite_unicode => 1,
    };
    
    my $dbh = DBI->connect($dsn, $user, $pass, $options);
}


$dbh->do(q{
    CREATE TABLE person (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name  VARCHAR(255),
        last_name   VARCHAR(255)
    )
});


eval{
    my $stmt = $dbh->prepare(q{INSERT INTO person (first_name, last_name) VALUES (?, ?)});
    for my $data ( ['foo','bar'], ['baz','maz'], ['mep','hep'] ) {
    $stmt->execute(@{$data}[0,1]);
    }
    
    my $sth = $dbh->prepare(q{SELECT id,first_name,last_name FROM person});
    $sth->execute;
    while ( my $data = $sth->fetchrow_arrayref ) {
    printf "ID:         %s\n", $data->[0];
    printf "First Name: %s\n", $data->[1];
    printf "Last Name:  %s\n", $data->[2];
    }
    
    $dbh->commit();
};

if ($@){
    print "$@\n";
}

my $t1 = Benchmark->new();
my $td = timediff($t1, $t0);
print "Dauer: ", timestr($td),"\n";
