#!/usr/bin/perl -w
use strict;

use Tk;
use Tk::Grid::Utils qw(gridConfig gridMulti set);
use Tk::TableMatrix;
use File::Basename;

my ($cur_del_ext, $cur_sav_ext);
my %table;
my %del_file;

my $mw = MainWindow->new();
my $pxm = $mw->Photo(-file => 'C:\Perl\eg\aspSamples\aspfdr.gif');

my (undef, $fo, $fm, $fu) = gridConfig(
    
    $mw,
    {-row       => [qw/64 544v 32/],
     -col       => [qw/800v/],
     -minsize   => 1 },
    
    $mw->Frame(),
    {-row       => [qw/32 32/],
     -col       => [qw/96 96v 32 96/],
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

my ($del_dir_lb, $del_dir_en, $del_dir_bt, $del_dir_om,
    $sav_dir_lb, $sav_dir_en, $sav_dir_bt, $sav_dir_om,
    $files_tm,
    $read_bt, $delete_bt, $exit_bt) = gridMulti(
        
    $fo->Label(),                   {set 0,0},
    $fo->Entry(),                   {set 0,1},
    $fo->Button(),                  {set 0,2},
    $fo->Optionmenu(),              {set 0,3},
    
    $fo->Label(),                   {set 1,0},
    $fo->Entry(),                   {set 1,1},
    $fo->Button(),                  {set 1,2},
    $fo->Optionmenu(),              {set 1,3},
    
    $fm->Scrolled('TableMatrix'),   {set 0,0},
    
    $fu->Button(),                  {set 0,0},
    $fu->Button(),                  {set 0,1},
    $fu->Button(),                  {set 0,2},
);

$del_dir_lb->configure(-text => 'Verz. 1 (löschen)', -anchor => 'w');
$del_dir_om->configure(-variable => \$cur_del_ext);
$del_dir_bt->configure(-image => $pxm,
                       -command => sub {choose_dir($del_dir_en, $del_dir_om)});

$sav_dir_lb->configure(-text => 'Verz. 2 (bleibt)', -anchor => 'w');
$sav_dir_om->configure(-variable => \$cur_sav_ext);
$sav_dir_bt->configure(-image => $pxm,
                       -command => sub {choose_dir($sav_dir_en, $sav_dir_om)});

$files_tm->configure(-rows => 10, -cols => 2, -variable => \%table);
$files_tm->colWidth(0,-768,1,-32);

$read_bt->configure(  -text => 'vergleichen', -command => sub { compare() });
$delete_bt->configure(-text => 'löschen', -command => sub { delete_files() });
$exit_bt->configure(  -text => 'beenden', -command => sub { beenden() });
 
MainLoop;

sub compare {
    
    my $del_dir = $del_dir_en->get();
    %del_file = map { ((fileparse($_, $cur_del_ext))[0], $_) }
                glob("$del_dir/*$cur_del_ext");
    
    my $sav_dir = $sav_dir_en->get();
    my @files = sort
                grep { exists $del_file{$_} }
                map  { (fileparse($_, $cur_sav_ext))[0] }
                glob ("$sav_dir/*$cur_sav_ext");
    
    fill_table(\@files);    
}

sub delete_files{
    
    my @files;
    my $rows = $files_tm->cget('-rows');
    for my $row (0 .. $rows - 1) {
        my $cb = $files_tm->windowCget("$row,1",'-window')->cget('-variable');
        if ($$cb) {
            unlink $del_file{$table{"$row,0"}};
        }
        else {
            push @files, $table{"$row,0"};
        }
    }
    fill_table(\@files);
}
sub beenden { exit }
sub choose_dir {
    my ($en, $om) = @_;
    
    my $dir = $mw->chooseDirectory(-initialdir => $en->get() || 'C:/Filme');
    $en->delete('0','end');
    $en->insert('end', $dir);
    
    my %ext = map {s/^.*(\.[^.]*)$/$1/; ($_, $_)} glob("$dir/*.*");
    $om->configure(-options => [(sort keys %ext)]);
    
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