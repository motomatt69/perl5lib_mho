#!/usr/bin/perl -w
use strict;

use RDK8FT::MON_DB::MON;
use RDK8FT::DB::RDK8FTP;
use RDK8FT::DB::PROMIX::Colli;
use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

#gewicht_aus_moni_in_db();
#gewicht_aus_rdk8db_in_db();
#gewicht_aus_promix_in_db();
db_nach_excel();

sub gewicht_aus_moni_in_db{
    
    my $dbh = RDK8FT::MON_DB::MON->new;
    
    my $it = $dbh->monitor->retrieve_all;
    while (my $alstom_id = $it->next) {
        print $alstom_id->position,"   \n";
                
        my ($eintrag1) = $dbh->mon_gewicht->find_or_create({alstom_id => $alstom_id->position});
        my ($eintrag2) = $dbh->mon_gewicht->search (alstom_id => $alstom_id->position);
        my $g_moni = $eintrag2->g_moni($alstom_id->weight_prog);
        $eintrag2->update();
    }
}

sub gewicht_aus_rdk8db_in_db{
    
    my $dbhmon = RDK8FT::MON_DB::MON->new;
    my $dbhrdk = RDK8FT::DB::RDK8FTP->new;
    
    my $it = $dbhrdk->bauteil->retrieve_all;
    
    while (my $bauteils = $it->next) {
        my $bauteil_id = $bauteils->bauteil_id;
        print $bauteils->alstom_id,"   \n";
        
        if ($bauteils->alstom_id =~ m{^8081} or $bauteils->alstom_id =~ m{^8084}){
            print "bandage\n";
            next;
        }
        
        my ($btinfo) = $dbhrdk->bauteilinfo->search({bauteil => $bauteil_id});
        
        
        my ($eintrag1) = $dbhmon->mon_gewicht->find_or_create({alstom_id => $bauteils->alstom_id});
        my ($eintrag2) = $dbhmon->mon_gewicht->search (alstom_id => $bauteils->alstom_id);
        my $g_rdk = $eintrag2->g_rdk8db($btinfo->gewicht);
        $eintrag2->update();
    }
    
}

sub gewicht_aus_promix_in_db{
    
    my $anr = '090468';
    my $u_anr = '1';
    my @zngs = RDK8FT::DB::PROMIX::Colli::get_zeichnungen($anr, $u_anr); 
    
    my $dbhmon = RDK8FT::MON_DB::MON->new;
    
    foreach my $zng (@zngs) {
        
        if ($zng->zng_nr =~ m{^21081} or $zng->zng_nr =~ m{^21084}) {next};
        my (@aups) = RDK8FT::DB::PROMIX::Colli::list_hauptpos($zng);
        
        my $alstom_id;
        foreach my $aup (@aups){
            $alstom_id = $aup->aup_bez();
            $alstom_id =~ s/\.//;
        }
        
        print $alstom_id,"  ";
        my $znr = $zng->zng_nr;
        print $znr,"  ";
        
        my $zng_gewicht = RDK8FT::DB::PROMIX::Colli::get_zeichnungsgewicht($zng);
        print $zng_gewicht,"\n";
        
        my ($eintrag1) = $dbhmon->mon_gewicht->find_or_create({alstom_id => $alstom_id});
        my ($eintrag2) = $dbhmon->mon_gewicht->search (alstom_id => $alstom_id);
        my $g_prom = $eintrag2->g_promix($zng_gewicht);
        $eintrag2->update();
    
    }
}


sub db_nach_excel{
    my $dbhmon = RDK8FT::MON_DB::MON->new;
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 1;
    my $path = "c:\\dummy\\gewicht_moni2rdk8ft.xls";
    
    my $book = $excel->Workbooks->open($path);
    my $sheet= $book->Worksheets(1);
    
    
    my $it = $dbhmon->mon_gewicht->retrieve_all();
    
    my $z = 3;
    while (my $gewichts = $it->next()){
        my $alstom_id = $gewichts->alstom_id;
        my $g_moni = $gewichts->g_moni;
        $g_moni =~ s/\./,/;
        my $g_rdk = $gewichts->g_rdk8db;
        $g_rdk =~ s/\./,/;
        my $g_promix = $gewichts->g_promix;
        $g_promix =~ s/\./,/;

    
        $sheet->Range("A$z")->{'Value'} = $alstom_id;
        $sheet->Range("B$z")->{'Value'} = $g_moni;
        $sheet->Range("C$z")->{'Value'} = $g_rdk;
        $sheet->Range("D$z")->{'Value'} = $g_promix;
        
        $z++;
    }
    
    $book->Save;
    print "Fertig";
    $book->Close;
    $excel-> Quit;
}
