#!/usr/bin/perl -w
use strict;
use Tk;
use Tk::ProgressBarPlus;


my $file = "";
my $prozent=0;

my $mw = MainWindow->new(-title=>'Packliste erstellen');

#Horizontale Menubar
my $frm_o = $mw->Frame(-relief=>'ridge',
                    -bd=>5);

#Menubuttons
my $m_file=$frm_o->Menubutton(-text=>"Lieferschein",
                        -underline=>1);
my $m_packliste=$frm_o->Menubutton(-text=>'Packliste',
                                -underline=>1);
#Menubuttonsanordnen
$frm_o->grid(-row=>0,
              -column=>0,
              -sticky=>'w');
$m_file->grid(-in=>$frm_o,-row=>0,-column=>0,-sticky=>'w');
$m_packliste->grid(-in=>$frm_o,-row=>0,-column=>1);

#Untermenus
$m_file->command(-label=>'auswählen',
                 -command=>sub {vorlage_waehlen()});
$m_file->separator();
$m_file->command(-label=>"Exit",
                 -underline =>1,
                 -command => sub {exit 0;});

$m_packliste->command(-label=>'erstellen',
                      -command=>sub{Packliste($file)});
 
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

sub vorlage_waehlen {
    $file =  $m_file->getOpenFile();
    if ($file !~ m/.+Lieferschein.+\.csv/) {
        $file ="kein gültiger Lieferschein"
    }
}

sub Packliste{
    use Lieferschein::ReadWrite qw(read_csv write_csv);
    use Lieferschein::Excel qw(write_excel);
    use Lieferschein::SQLexport qw(sql_export);
    
    my $file=shift @_;
    my ($in_file, $out_file);    
    
    if ($file =~ m/.+Lieferschein.+\.csv/) {
        $file =~ s/(.+).csv/$1/;
        $in_file = "$file.csv";
        $out_file = "$file.txt";
    
        #print "$file\n";
        #print "$in_file\n";
        #print "$out_file\n";
       
        my $daten_hash_ref = read_csv($in_file);
        write_csv($out_file, $daten_hash_ref);
        #write_excel($out_file, $daten_hash_ref, \&fortschritt);
        sql_export($out_file, $daten_hash_ref,);
    }
}

sub fortschritt {
    my ($percent_done) = @_;
    $prozent = $percent_done;
    $mw->update();
    #print "Aktueller Fortschritt $percent_done\n";
}