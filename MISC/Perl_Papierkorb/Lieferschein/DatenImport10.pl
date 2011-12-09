#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::ProgressBarPlus;

#use Tk::XPMs qw(openfolder_xpm);
#use Tk::TableMatrix;
#use Tk::Grid::Utils qw(gridConfig set);

my $file = "";
my $prozent=0;

my $mw = MainWindow->new(-title=>'Packliste erstellen');

#Horizontale Menubar
my $frm_o = $mw->Frame(-relief=>'ridge',
                    -bd=>5);

#Menubuttons
my $m_packliste=$frm_o->Menubutton(-text=>"Packliste",
                        -underline=>1);
my $m_bocadPS=$frm_o->Menubutton(-text=>'bocadPS',
                                -underline=>1);
#Menubuttonsanordnen
$frm_o->grid(-row=>0,
              -column=>0,
              -sticky=>'w');
$m_packliste->grid(-in=>$frm_o,-row=>0,-column=>0,-sticky=>'w');
$m_bocadPS->grid(-in=>$frm_o,-row=>0,-column=>1);

 
#Untermenus
$m_packliste->command(-label=>'erstellen',
                 -command=>sub {pl_toplevel()});
$m_packliste->separator();
$m_packliste->command(-label=>"Exit",
                 -underline =>1,
                 -command => sub {exit 0;});

$m_bocadPS->command(-label=>'auswählen',
                      -command=>sub{vorlage_waehlen()});

$m_bocadPS->command(-label=>'importieren',
                      -command=>sub{bocadPSimport($file)});

  
#Hauptframe
my $frm_m=$mw->Frame(-relief=>'sunken',
                     -bd=>2);
$frm_m->grid(-row=>1,-column=>0);

#ProgressbarPlus
my $progress = $mw->ProgressBarPlus(-width => 40,
                   -length => 500,
                   -height => 10,
                   -from => 0,
                   -to => 100,
                   -anchor => 'w',
                   -blocks => 1,
                   -colors => [0, 'khaki1', 10, 'khaki2' , 20, 'gold1', 30, 'gold2', 40, 'goldenrod1',
                               50, 'goldenrod2', 60, 'goldenrod3', 70, 'DarkGoldenrod3', 80, 'goldenrod4', 90, 'orange4'],
                   -variable => \$prozent,
                   -showvalue => '1',
                   -valuecolor => 'IndianRed4',
                   -font => '9x15',
                   -valueformat => '<%s %%>',);
$progress->grid(-in=>$frm_m,-row=>0,-column=>0);

#UntersterFrame
my $frm_u=$mw->Frame(-relief=>'sunken',
                     -bd=>2);
$frm_u->grid(-row=>2,-column=>0);


my $lbl1=$frm_u->Label(-text=>"Lieferschein:",
                       -bg=>'khaki1');
my $lbl2=$frm_u->Label(-textvariable=>\$file,
                    -bg=>'khaki1');
$lbl1->grid(-in=>$frm_u,-row=>0,-column=>0);
$lbl2->grid(-in=>$frm_u,-row=>0,-column=>1);


MainLoop;

# Subs zum Packliste erstellen XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

my ($inp,$inp1,$tl);
sub pl_toplevel {
    if (! Exists($tl)) {
        $tl=$mw->Toplevel(-title=>"LSNR");
        #LSNr
        $tl->Label(-text=>'Lieferscheinnummer:')->grid(-row=>0,-column=>0);
        $tl->Label(-text=>'(8 Stellen)')->grid(-row=>1,-column=>0);
        $inp=$tl->Entry()->grid(-row=>2,-column=>0);
        
        $inp->bind('<Return>',sub {checkLSNr()});
        #PLNr
        $tl->Label(-text=>'Packlistennummer:')->grid(-row=>0,-column=>1);
        $tl->Label(-text=>'(?????rev?)')->grid(-row=>1,-column=>1);
        $inp1=$tl->Entry()->grid(-row=>2,-column=>1);
        $inp1->bind('<Return>',sub {checkLSNr()});
        my $bto_Ok = $tl->Button(-text=>'Ok',
                                 -command=> sub {checkLSNr()})->grid(-row=>3,-column=>0,-columnspan=>2);
    }else{
        $tl->deiconify();
        $tl->raise();
    }
}

sub checkLSNr {
    my $lsnr=$inp->get();
    my $plnr=$inp1->get();
    $tl->withdraw;
    if ($lsnr =~m/^\d{8}$/ and $plnr =~m/^\d{5}rev\d+$/) {
        
        &packliste($lsnr,$plnr)
    }else{
        pl_toplevel()
    }
}

sub packliste{
    use Lieferschein::mho;
    use Lieferschein::Promix qw(getKopfHandle getLieferHandle);
    use Lieferschein::Excel1 qw(write_excel);
    
    my $lsnr = $_[0];my $plnr=$_[1];
    #$lsnr=99498677;
    print $lsnr;
#Promix Abfrage
    my $dbh = Lieferschein::Promix::connect();

#Zugehörige Hp aus Datenbank holen
    my $dbh1 = Lieferschein::mho::connect();
    print "Verbunden\n";
# Abfragen vorbereiten
    my $kh = getKopfHandle($dbh);#Lieferschein Kopfzeilen abfragen
    my $lh = getLieferHandle($dbh);#Lieferschein zugehörige Bauteile abfragen
    my $BteAbf=$dbh1->prepare(qq/SELECT anz,prof,lae,breit,hoch,gew,znr,hp,zchn_nr_ku,bauteil_ku FROM bte WHERE znr = ? AND hp = ?;/);#Bauteileigenschaften abfragen
#Abfragen ausführen und DatenHashRef erstellen
    my ($count,%dat);
    #Kopfzeile abfragen und ausfüllen
    $kh->execute($lsnr);
    my @lsko = $kh->fetchrow_array();
    print "$lsko[0] : $lsko[1] \n\n";
    my $kozeile="080335-".$plnr.";".$lsnr.";".$lsko[1].";".$lsko[0];
    $dat{0}=\$kozeile;
    $kh->finish();
    #Datensätze der Hauptpositionen hash
    $lh->execute($lsnr);
        while (my @lo = $lh->fetchrow_array()) {
            $lo[0] += 0;#Leerstellen bei der Teilsystemnummer abschneiden
            $BteAbf->execute($lo[0],$lo[1]);
            my @bte=$BteAbf->fetchrow_array();
            my @daten=(int $lo[2], $bte[1], $bte[2], $bte[3], $bte[4], $bte[5], $lo[0], $lo[1], $bte[8], $bte[9]); 
            $dat{$lo[0].$lo[1]} = \@daten;
           # print "znr: $lo[0] hp: $lo[1] anz: $lo[2]\n";
           # print "prof: $bte[0]\n";
           # print @daten;
           # print "\n";
            $count++
        }
        
    print "$count datensätze ausgelesen\n";
    $lh->finish();
    $BteAbf->finish;
    $dbh->disconnect();
    $dbh1->disconnect();
    print "Fertig\n";
    my $daten_hash_ref =  \%dat;
    
    write_excel($daten_hash_ref, \&fortschritt);

}    
 
# Subs für bocadPS import XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
sub vorlage_waehlen {
    $file =  $m_packliste->getOpenFile();
    if ($file !~ m/.+Lieferschein.+\.csv/) {
        $file ="kein gültiger Lieferschein"
    }
}

sub bocadPSimport{
    use Lieferschein::ReadWrite qw(read_csv write_csv);
    use Lieferschein::SQLexport qw(sql_export);
    
    my $file=shift @_;
    my ($in_file, $out_file);    
    
    if ($file =~ m/.+Lieferschein.+\.csv/) {
        $file =~ s/(.+).csv/$1/;
        $in_file = "$file.csv";
        $out_file = "$file.txt";
    
        my $daten_hash_ref = read_csv($in_file);
        write_csv($out_file, $daten_hash_ref);
        sql_export($out_file, $daten_hash_ref,);
    }
}

sub fortschritt {
    my ($percent_done) = @_;
    $prozent = $percent_done;
    $mw->update();
    #print "Aktueller Fortschritt $percent_done\n";
}