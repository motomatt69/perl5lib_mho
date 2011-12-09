use strict;
use RDK8FT::DB::RDK8FTP;
#use DB::Promix;
use RDK8FT::DB::PROMIX::Colli;
use File::Spec;
use File::Slurp;

my ($anr, $uanr) = ('090468', 1);

my $cdbh = RDK8FT::DB::RDK8FTP->new();
my (@zngs) = RDK8FT::DB::PROMIX::Colli::get_zeichnungen($anr, $uanr);


my @data;
my @lines;
for my $z (@zngs){
    my $znr = $z->zng_nr;
    my ($zng) = RDK8FT::DB::PROMIX::Colli::get_zeichnung($anr, $uanr, $znr);
    
    if ($zng->zng_nr =~ m/\d{5}-\d{4}/) {
        next
    }
    else{
        print $zng->zng_nr,'  ',$zng->zng_aenind,"\n";
    }
    
    my (@bts) = RDK8FT::DB::PROMIX::Colli::list_hauptpos($zng);
    for my $bt (@bts){
        my ($hpos, $bez) = ($bt->aup_pos(), $bt->aup_bez);
        print $hpos,"  ",$bez,"\n";
        
        my ($hp) = RDK8FT::DB::PROMIX::Colli::get_hauptpos($zng, $hpos);
        push @data, ([  $zng->zng_nr,
                        $zng->zng_aenind,
                        $hp->aup_pos,
                        $hp->aup_art_nr,
                        $hp->aup_art_wst,
                        $hp->aup_lang,
                        $hp->aup_breit,
                        $hp->aup_gewicht,
                        $hp->aup_menge,
                        "\n"]);
        
        
        my @abts = RDK8FT::DB::PROMIX::Colli::get_anbauteile($hp);
        for my $abt (@abts) {
            push @data, ([$zng->zng_nr,
                          $zng->zng_aenind,
                          $abt->aup_pos,
                          $abt->aup_art_nr,
                          $abt->aup_art_wst,
                          $abt->aup_lang,
                          $abt->aup_breit,
                          $abt->aup_gewicht,
                          $abt->aup_menge,
                          "\n"]);
        }
    }
}

@lines = map{join ';', @$_} @data;
my @dirs = qw(c: dummy);
my $p = File::Spec->catfile(@dirs, 'rdk8material.csv');

write_file($p, @lines);



1;
    


