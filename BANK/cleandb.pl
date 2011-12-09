#!/usr/bin/perl -w
use strict;
use BANK::DB::STRUCT;

unterkat_ueber_regex_setzen();
#del_anfue();

sub kategoriewechsel{
    my $cdbh = BANK::DB::STRUCT->new();
    
    my ($kat) = $cdbh->kategorien->search(kategorie => 'Essen'); #empf_abse
    my $katorg_id = $kat->ID();
    
    ($kat) = $cdbh->kategorien->search(kategorie => 'Leben'); #empf_abse
    my $katnew_id = $kat->ID();
    
    
    my $dummy;
}

sub del_anfue{
    my $cdbh = BANK::DB::STRUCT->new();
    
    my @kats = $cdbh->buchungen->retrieve_all();
    for my $rec (@kats){
        my $bez3 = $rec->verzweck3();
        ($bez3) = $bez3 =~ m/"(.*)"/;
        print $bez3,"\n";
        $rec->verzweck3($bez3);
        $rec->update();
    }        
}

sub unterkat_ueber_regex_setzen{
    my $cdbh = BANK::DB::STRUCT->new();
    
    my (@reg2uk) = $cdbh->regex2unterkat->retrieve_all();
    
    
    my %reg2uk = map {$_->regex() => $_->unterkat_ID()} @reg2uk;
    
    my @buchs = $cdbh->buchungen->retrieve_all();
    
    for my $b(@buchs){
        for my $regex (keys %reg2uk){
            my $e_a = $b->empf_abse_id()->empf_abse();
            my $vzw1 = $b->verzweck1();
            my $vzw2 = $b->verzweck2();
            if ($e_a =~ m/$regex/){
                print "Treffer: $regex  ::  $e_a\n";
                $b->unterkat_ID($reg2uk{$regex});
                $b->update();
            }
            elsif($vzw1 =~ m/$regex/){
                print "Treffer: $regex  ::  $vzw1\n";
                $b->unterkat_ID($reg2uk{$regex});
                $b->update();
            }
            elsif($vzw2 =~ m/$regex/){
                print "Treffer: $regex  ::  $vzw2\n";
                $b->unterkat_ID($reg2uk{$regex});
                $b->update();
            }
        }
    }
    
    my $dummy;
    
}

