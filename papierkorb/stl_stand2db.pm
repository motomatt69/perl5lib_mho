package RDK8FT::stl_stand2db;
use strict;
use RDK8FT::File::Paths;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::MON_DB::MON;    

sub beastand_fuellen{
    my $dbh_mon = RDK8FT::MON_DB::MON->new();
    
    my @alstom_ids = RDK8FT::alstom_id_aus_mon::get_alstom_ids($dbh_mon);
    
    my $dbh_rdk = RDK8FT::DB::RDK8FTP->new();
    my $dbh_rdk_sql = $dbh_rdk->dbh();
    
    my %alsto = map {$_ => undef} @alstom_ids;
    my $id_list = join ',', @alstom_ids;
    
    
    
    
    
    
    
    
    
    
    
    my $dummy;
#    foreach my $dat (@data) {
#        my $alstom_id = $dat->position();
#        my ($gew, $beastand, $color) = get_bearbeitungsstand($alstom_id);
#        $dat->gewicht($gew);
#        $dat->beastand($beastand);
#        $dat->color($color);
#        
#        my $rev = get_rev($alstom_id);
#        $dat->rev($rev);
#        
#        my $info_from_bf = ($color == 3) ? 'no dwg'
#                            : ($color == 26) ? 'no fitcat'
#                            : '';
#        $dat->info_from_bf($info_from_bf);
#        $dat->update();
#    }
}


#
#sub get_bearbeitungsstand{
#    
#    my ($alstom_id) = @_;
#    #next if !($alstom_id);
#    print "Bearbeitung $alstom_id \n";
#    
#    my $gew;
#    my ($v_bt_inf) = RDK8FT::DB::RDK8FTP::v_bauteilinfo->search(alstom_id => $alstom_id);
#    if ($v_bt_inf) {
#        $gew = $v_bt_inf->gewicht();
#    }
#    if ($gew) {$gew = sprintf ("%.f", $gew)};
#    #if ($gew) {($gew) = $gew =~ m/(\d+)/}; #Pkt durch Komma ersetzen wegen excel
#    
#    my ($it) = RDK8FT::DB::RDK8FTP::v_bauteil2termin->search(alstom_id => $alstom_id);
#    my ($beastand, $color);
#    if ($it) {
#        my $znr = $it->zeichnungsnummer;
#        $znr =~ s/-/_/;
#        my ($datei) = RDK8FT::DB::RDK8FTP::datei->search_like(path => '%'.$znr.'%'.'txt');
#        if ($datei) {
#            my $ver = $datei->verarbeitet;
#            my $path = $datei->path;
#            my $endung = substr ($path,-4,4);
#                if ($endung eq '.txt') {
#                
#                ($beastand, $color)
#                = ($ver == 0)
#                ? ('Stl-Liste noch nicht erstellt',45)
#                
#                : ($ver == 1)
#                ? ('Stl-Liste zum Einspielen in Promix bereit',44)
#                
#                : ($ver == 10)
#                ? ('Promix eingespielt, Einzelteilzeichnungen fehlen', 26)
#                
#                : ($ver == 15)
#                ? ('Promix eingespielt, Einzelteilzeichnungen vorhanden', 43)
#                
#                : ($ver == 20)
#                ? ('Fertig fuer AV', 43)
#                
#                : ('Fehler', 3);
# 
#            #print "$text\n";
#            }
#        }
#        else{
#            $beastand =  "keine Stückliste";
#        }
#    }
#    else{
#        $beastand =  "Zeichnung fehlt";
#        $color = 3;
#    }
#    
#    return ($gew, $beastand, $color)
#}
#
#sub get_rev{
#    my ($alstom_id) = @_;
#    
#    my ($rev) = RDK8FT::DB::RDK8FTP::v_bauteilzeichnung->search(alstom_id => $alstom_id);
#    if ($rev) {
#        return  $rev->indexnr;
#    }
#}
#    
#    
    
    
        
1;
