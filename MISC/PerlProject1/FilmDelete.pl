#!/usr/bin/perl -w
use strict;
use Tk;
use File::Basename;
use Win32API::File qw(DeleteFile);
use File::Copy;

my %del_dir;
my %sav_dir;
my $cur_del_ext;
my $cur_sav_ext;
my %table;

my $mw = MainWindow->new();

my $fo = $mw->Frame();
my $fm = $mw->Frame();
my $fu = $mw->Frame();

$mw->gridColumnconfigure(0, -minsize => 800, -weight => 5);
$mw->gridRowconfigure(   0, -minsize => 64,  -weight => 0);
$mw->gridRowconfigure(   1, -minsize => 504, -weight => 5);
$mw->gridRowconfigure(   2, -minsize => 32,  -weight => 0);

$fo->gridColumnconfigure(0, -minsize => 80,  -weight => 0);
$fo->gridColumnconfigure(1, -minsize => 620, -weight => 5);
$fo->gridColumnconfigure(2, -minsize => 32,  -weight => 0);
$fo->gridColumnconfigure(3, -minsize => 64,  -weight => 0);
$fo->gridRowconfigure(   0, -minsize => 32,  -weight => 0);
$fo->gridRowconfigure(   1, -minsize => 32,  -weight => 0);

$fm->gridColumnconfigure(0, -minsize => 800, -weight => 5);
$fm->gridRowconfigure(   0, -minsize => 504, -weight => 5);

$fu->gridColumnconfigure(0, -minsize => 267, -weight => 5);
$fu->gridColumnconfigure(1, -minsize => 266, -weight => 5);
$fu->gridColumnconfigure(2, -minsize => 267, -weight => 5);
$fu->gridRowconfigure(   0, -minsize => 32,  -weight => 0);

my $pxm = $mw->Photo(-file => 'C:\Perl\eg\aspSamples\aspfdr.gif');

my $del_dir_lb = $fo->Label(-text => 'Verz. 1 (löschen)', -anchor => 'w');
my $del_dir_en = $fo->Entry();
my $del_dir_om = $fo->Optionmenu(-variable => \$cur_del_ext);
my $del_dir_bt = $fo->Button(-image => $pxm, -command => sub { choose_dir($del_dir_en, $del_dir_om) });

my $sav_dir_lb = $fo->Label(-text => 'Verz. 2 (bleibt)', -anchor => 'w');
my $sav_dir_en = $fo->Entry();
my $sav_dir_om = $fo->Optionmenu(-variable => \$cur_sav_ext);
my $sav_dir_bt = $fo->Button(-image => $pxm, -command => sub { choose_dir($sav_dir_en, $sav_dir_om) });

my $files_tm   = $fm->Scrolled('TableMatrix',-rows => 10, -cols => 2, -variable => \%table);
$files_tm->colWidth(0,-768,1,-32);

my $read_bt    = $fu->Button(-text => 'vergleichen', -command => sub { compare() });
my $delete_bt  = $fu->Button(-text => 'löschen',     -command => sub { delete_files() });
my $exit_bt    = $fu->Button(-text => 'beenden',     -command => sub { beenden() });

$fo->grid(        -row => 0, -column => 0, -sticky => 'nswe');
$fm->grid(        -row => 1, -column => 0, -sticky => 'nswe');
$fu->grid(        -row => 2, -column => 0, -sticky => 'nswe');

$del_dir_lb->grid(-row => 0, -column => 0, -sticky => 'nswe');
$del_dir_en->grid(-row => 0, -column => 1, -sticky => 'nswe');
$del_dir_bt->grid(-row => 0, -column => 2, -sticky => 'nswe');
$del_dir_om->grid(-row => 0, -column => 3, -sticky => 'nswe');

$sav_dir_lb->grid(-row => 1, -column => 0, -sticky => 'nswe');
$sav_dir_en->grid(-row => 1, -column => 1, -sticky => 'nswe');
$sav_dir_bt->grid(-row => 1, -column => 2, -sticky => 'nswe');
$sav_dir_om->grid(-row => 1, -column => 3, -sticky => 'nswe');

$files_tm->grid(  -row => 0, -column => 0, -sticky => 'nswe');

$read_bt->grid(   -row => 0, -column => 0, -sticky => 'nswe');
$delete_bt->grid( -row => 0, -column => 1, -sticky => 'nswe');
$exit_bt->grid(   -row => 0, -column => 2, -sticky => 'nswe');

MainLoop;

sub choose_dir {
    my ($en, $om) = @_;
    
    my $dir = $mw->chooseDirectory(-initialdir => $en->get() || 'C:/Filme');
    $en->delete('0','end');
    $en->insert('end', $dir);
    
    my %ext;
    my @files = glob("$dir/*.*");
    for my $file (@files) {
        my ($filename,$path,$ext) = fileparse($file,qr/\.[^.]*/);
        #print "$file $path $filename $ext\n";
        $ext{$ext}=$ext;
    }
    
    $om->configure(-options => [(sort keys %ext)]);
}

sub compare {
    
    my %files = ();
    
    my $del_dir = $del_dir_en->get();
    my @del_dir_files = glob("$del_dir/*$cur_del_ext");
    
    for my $file (@del_dir_files) {
        my ($filename, $path, $ext) = fileparse($file, $cur_del_ext);
        if ($ext eq $cur_del_ext) {
            $files{$filename} = 0;
            $del_dir{$filename} = $file; }
    }
    
    my $sav_dir = $sav_dir_en->get();
    my @sav_dir_files = glob("$sav_dir/*$cur_sav_ext");
    for my $file (@sav_dir_files) {
        my ($filename, $path, $ext) = fileparse($file, $cur_sav_ext);
        if ($ext eq $cur_sav_ext) {
            if (exists $files{$filename}) {
                $files{$filename} = 1;
                $sav_dir{$filename} = $del_dir{$filename};
            }
        }   
    }
    
    my $o_rows = $files_tm->cget('-rows');
    if ($o_rows) { map { $files_tm->windowDelete("$_,1") } (0 .. $o_rows - 1);}
    
    $files_tm->configure(-rows => 0);
    %table = ();
    
    my $row = 0;
    for my $filename (sort keys %files) {
        next unless ($files{$filename} == 1);
        
        my $rows = $files_tm->cget('-rows') - 1;
        if ($rows < $row) { $files_tm->configure(-rows => $row);}
        $files_tm->set("$row,0",$filename);
        my $cb = $mw->Checkbutton();
        $files_tm->windowConfigure("$row,1",-window => $cb);
        $row++;
    }
}

sub delete_files {
    
    my $rows = $files_tm->cget('-rows');
    
    my $del_dir = $del_dir_en->get();
    
    for (my $row = 0; $row < $rows; $row++) {
        my $file   = $files_tm->get("$row,0");
        my $cb     = $files_tm->windowCget("$row,1",'-window');
        my $cb_ref = $cb->cget('-variable');
        if ($$cb_ref) {
            my $del_file = "$del_dir/$file$cur_del_ext";
            unless (unlink ($del_file)) {
                my $del2 = $sav_dir{$file};
                unless (unlink ($del2)) { print "$del2 kann nicht gelöscht werden\n"; }
            }
            
        }
    }
}

sub beenden { exit; }