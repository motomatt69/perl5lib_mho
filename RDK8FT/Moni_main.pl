#!/usr/bin/perl -w
use strict;
use RDK8FT::AlstMoniInDB;
use RDK8FT::db2alstom;
use RDK8FT::db2ines;
use RDK8FT::ines2db;
use RDK8FT::WOCHENBERICHT;
use Tk::Utils::MainApp::MVC::View::Trace;
use Tk;
use File::Copy;

my $alstmoni2db = RDK8FT::AlstMoniInDB->new();
my $db2ines = RDK8FT::db2ines->new();
my $ines2db = RDK8FT::ines2db->new();
my $db2alstom = RDK8FT::db2alstom->new();

my $mw = MainWindow->new();

my $alst_entry_b    = $mw->Button(-text => "Monitoring nach DB")
                                ->grid(-row => 0, -column => 0, -sticky => "nsew");
my $db2ines_b       = $mw->Button(-text => "DB zu Ines")
                                ->grid(-row => 1, -column => 0, -sticky => "nsew");
my $bea_fill_b      = $mw->Button(-text => "Stand Bearbeitung in DB")
                                ->grid(-row => 2, -column => 0, -sticky => "nsew");
my $db2alstom_b     = $mw->Button(-text => "DB nach Monitoring")
                                ->grid(-row => 3, -column => 0, -sticky => "nsew");
my $wochenbericht_b = $mw->Button(-text => "Wochenbericht")
                                ->grid(-row => 4, -column => 0, -sticky => "nsew");
my $wochenbericht_e = $mw->Entry(-text => "00")
                                ->grid(-row => 5, -column => 0, -sticky => "nsew");

my $trace_t = Tk::Utils::MainApp::MVC::View::Trace->new($mw);
$trace_t->grid(6, 0);

$alstmoni2db->addObserver($trace_t);
$db2ines->addObserver($trace_t);
$ines2db->addObserver($trace_t);
$db2alstom->addObserver($trace_t);

my $exit_b          = $mw ->Button(-text => "ende")
                                ->grid(-row => 8, -column => 0, -sticky => "nsew");

$alst_entry_b   ->configure(-command => sub{start_alstomoni2db()});
$db2ines_b      ->configure(-command => sub{start_db2ines()});
$bea_fill_b     ->configure(-command => sub{start_ines2db()});
$db2alstom_b   ->configure(-command => sub{start_db2alstom()});
$wochenbericht_b->configure(-command => sub{wb_start()});

$exit_b->configure(-command => sub{exit}); 

Tk::MainLoop;

sub start_alstomoni2db{
    my $alstom_file = get_alstom_file();
    $alstmoni2db->set_alstom2db($alstom_file)
}

sub start_db2alstom{
    my $alstom_file = get_alstom_file();
    $db2alstom->set_db2alstom($alstom_file)
}

sub get_alstom_file{
    my ($rpath, $path, $file);
    
    while (!$file){
        $rpath =  $alst_entry_b->getOpenFile();
        ($path, $file) = $rpath =~ m/(^\S+)(Monitoring WEN KW \d{2}.xls)/;
    }
    my $alstom_file = 'Kopie von '.$file;
    my $spath = $path.$alstom_file;
        
    copy($rpath, $spath) or die "Copy failed: $1";
    
    return $alstom_file;
}

sub start_db2ines{
        
    my $kirchner_file = get_kirchner_file();
    $db2ines->set_db2ines($kirchner_file)
}

sub start_ines2db{
        
    my $kirchner_file = get_kirchner_file();
    $ines2db->set_ines2db($kirchner_file)
}

sub get_kirchner_file{
    
    my ($rpath, $path, $file);
    while (!$file){
        $rpath =  $db2ines_b->getOpenFile();
        ($path, $file) = $rpath =~ m/(^\S+)(Monitoring Kirchner_\d{2}.xls)/;
    }
    my $kirchner_file = 'Kopie von '.$file;
    my $spath = $path.$kirchner_file;
        
    copy($rpath, $spath) or die "Copy failed: $1";
    
    return $kirchner_file
}




sub wb_start{
    
    my $wb_file = 'Kopie von Fast Track 2010.xls';
    my $wb_kw = $wochenbericht_e->get();
        
    if ($wb_kw =~ m/^\d{2}$/){
        RDK8FT::WOCHENBERICHT->update($wb_file, $wb_kw);
    }
}
