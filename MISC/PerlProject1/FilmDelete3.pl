#!/usr/bin/perl -w
use strict;

use Slots qw(PROVIDE SIGNAL SLOT CONNECT DUMMY);
use Tk;
use Tk::Grid::Utils qw(gridConfig gridMulti set);
use Tk::TableMatrix;
use Tk::DirSelection;
use File::Basename;

#if ($^O =~ m!win!i) { use File::Glob::Windows }

my ($cur_del_ext, $cur_sav_ext);
my %table;
my %del_file;

PROVIDE SLOT, 'DIRECTORY_DEL_SELECTED', &choose_dir_del;
PROVIDE SLOT, 'DIRECTORY_SAV_SELECTED', &choose_dir_sav;
my $mw = MainWindow->new();


my $pxm = $mw->Photo(-file => 'C:\Programme\Perl\eg\aspSamples\aspfdr.gif');

my (undef, $fo, $fm, $fu) = gridConfig(
    
    $mw,
    {-row       => [qw/64 544v 32/],
     -col       => [qw/800v/],
     -minsize   => 1 },
    
    $mw->Frame(),
    {-row       => [qw/32 32/],
     -col       => [qw/96v 96/],
     -grid      => [set 0,0]},
    
    $mw->Frame(),
    {-row       => [qw/544v/],
     -col       => [qw/800v/],
     -grid      => [set 1,0]},
    
    $mw->Frame(),
    {-row       => [qw/32/],
     -col       => [qw/32v 32v 32v/],
     -grid      => [set 2,0]}
);

my ($del_dir_sl, $del_dir_om,
    $sav_dir_sl, $sav_dir_om,
    $files_tm,
    $read_bt, $delete_bt, $exit_bt) = gridMulti(
        
    $fo->DirSelection(),            {set 0,0},
    $fo->Optionmenu(),              {set 0,1},
    
    $fo->DirSelection(),            {set 1,0},
    $fo->Optionmenu(),              {set 1,1},
    
    $fm->Scrolled('TableMatrix'),   {set 0,0},
    
    $fu->Button(),                  {set 0,0},
    $fu->Button(),                  {set 0,1},
    $fu->Button(),                  {set 0,2},
);

$del_dir_sl->configure(-text => 'Verz. 1 (löschen)', -anchor => 'w');
$del_dir_sl->gridColumnconfigure(0, -minsize => 128);
$del_dir_om->configure(-variable => \$cur_del_ext);

$sav_dir_sl->configure(-text => 'Verz. 2 (sav)', -anchor => 'w');
$sav_dir_sl->gridColumnconfigure(0, -minsize => 128);
$sav_dir_om->configure(-variable => \$cur_sav_ext);

$files_tm->configure(-rows => 10, -cols => 2, -variable => \%table);
$files_tm->colWidth(0,-768,1,-32);

$read_bt->configure(  -text => 'vergleichen', -command => sub { compare() });
$delete_bt->configure(-text => 'löschen', -command => sub { delete_files() });
$exit_bt->configure(  -text => 'beenden', -command => sub { beenden() });
 
my $obj = DUMMY;
CONNECT $del_dir_sl, SIGNAL, 'DIRECTORY_SELECTED',
        $obj,        SLOT,   'DIRECTORY_DEL_SELECTED';
CONNECT $sav_dir_sl, SIGNAL, 'DIRECTORY_SELECTED',
        $obj,        SLOT,   'DIRECTORY_SAV_SELECTED';

print $del_dir_sl->gridBbox();
#syncSize($del_dir_sl, {-col => 0}, $sav_dir_sl, {-col => 0});
        
MainLoop;

sub compare {
    
    %del_file = map { ((fileparse($_, $cur_del_ext))[0], $_)}
                $del_dir_sl->readDirectory("*$cur_del_ext");
    
    my @files = sort
                grep { exists $del_file{$_} }
                map  { (fileparse($_, $cur_sav_ext))[0] }
                $sav_dir_sl->readDirectory("*$cur_sav_ext");
                
    fill_table(\@files);    
}

sub delete_files{
    
    my $del_dir = $del_dir_sl->get();
    my @files;
    my $rows = $files_tm->cget('-rows');
    for my $row (0 .. $rows - 1) {
        my $cb = $files_tm->windowCget("$row,1",'-window')->cget('-variable');
        if ($$cb) {
            #unlink $del_file{$table{"$row,0"}};
            my $ind = "$row,0";
            print "Lösche $del_file{$table{$ind}} \n";
        }
        else {
            push @files, $table{"$row,0"};
        }
    }
    fill_table(\@files);
}
sub beenden { exit }
sub choose_dir_del {
    my (undef,$sl) = @_;
    
    $del_dir_om->configure(-options => [$sl->readExtensions()]);
}
sub choose_dir_sav {
    my (undef,$sl) = @_;
    
    $sav_dir_om->configure(-options => [$sl->readExtensions()]);
}
sub fill_table {
    my ($files) = @_;
    my $o_rows = $files_tm->cget('-rows');
    if ($o_rows) { map { $files_tm->windowDelete("$_,1") } (0 .. $o_rows - 1);}
    %table = ();
    $files_tm->configure(-rows => 0);
    
    my $row = 0;
    for my $file (@$files) {
        
        my $rows = $files_tm->cget('-rows');
        $files_tm->configure(-rows => $row +1 ) if ($row >= $rows);
        
        $files_tm->set("$row,0", $file);
        $files_tm->windowConfigure("$row,1", -window => $mw->Checkbutton());
        $row++;
    }
}