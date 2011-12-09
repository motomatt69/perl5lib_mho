#!/usr/bin/perl -w
use strict;

use Tk;
use File::Copy;
use File::Path;

my $mw = MainWindow->new();
$mw->geometry('800x600');

my %gruppen = ('Das Erste'          => 'werbefrei',
               'ZDF'                => 'werbefrei',
               'ProSieben'          => 'private',
               'RTL Television'     => 'private',
               'RTL2'               => 'private',
               'Super RTL'          => 'private',
               'SAT.1'              => 'private',
               'VOX'                => 'private',
               'kabel eins'         => 'private',
               '3sat'               => 'werbefrei',
               'KIKA'               => 'werbefrei',
               'arte'               => 'werbefrei',
               'SWR Fernsehen'      => 'werbefrei',
               'Bayerisches'        => 'werbefrei',
               'WDR Köln'           => 'werbefrei',
               'hr Fernsehen'       => 'werbefrei',
               'MDR'                => 'werbefrei',
               'NDR'                => 'werbefrei',
               'rbb'                => 'werbefrei',
               'DAS VIERTE'         => 'nachbearbeiten',
               'TELE 5'             => 'private',
               'EinsFestival'       => 'werbefrei',
               'ANIXE'              => 'werbefrei',
              );

my $action = 'verschieben';

my $dir_bt = $mw->Button(-text      => 'Verzeichnis',
                         -command   => sub {waehle_dir()},
                         )->place(
                                -relx       => 0,
                                -rely       => 0,
                                -relwidth   => 0.250,
                                -relheight  => 0.100,
                                );

my $dir_en = $mw->Entry(
                        )->place(
                                -relx       => 0.250,
                                -rely       => 0,
                                -relwidth   => 0.750,
                                -relheight  => 0.100,
                                );

my $ok_bt = $mw->Button(-text       => 'ok',
                        -command    => sub {sort_filme()}
                        )->place(
                                -relx       => 0,
                                -rely       => 0.900,
                                -relwidth   => 0.333,
                                -relheight  => 0.100,
                                );

my $cp_bt = $mw->Button(-textvariable   => \$action,
                        -command        => sub {toggle_action()},
                        )->place(
                                -relx       => 0.333,
                                -rely       => 0.900,
                                -relwidth   => 0.334,
                                -relheight  => 0.100,
                                );

my $end_bt = $mw->Button(-text      => 'beenden',
                         -command   => sub { exit }
                         )->place(
                                -relx       => 0.667,
                                -rely       => 0.900,
                                -relwidth   => 0.333,
                                -relheight  => 0.100,
                                );

my $txt_lb = $mw->Scrolled('Listbox',
                           )->place(
                                -relx       => 0,
                                -rely       => 0.100,
                                -relwidth   => 1.000,
                                -relheight  => 0.800,
                            );

MainLoop;

sub waehle_dir {
    my $dir = $mw->chooseDirectory(-initialdir => 'C:/Filme');
    $dir_en->delete('0','end');
    $dir_en->insert('0',$dir);
}

sub sort_filme {
    my $dir = $dir_en->get();
    my %anz; my $i;
    $txt_lb->delete('0','end');
    chdir($dir);
    my @films = glob('*.ts');
    
    for my $film (@films) {
        $i++;
        my ($tag, $zeit, $prog, $titel) = split '_', $film;
        for my $pro (keys %gruppen) {
            if ($prog =~ m/$pro/i) {
                $prog = $pro;
            }
        }
        my $path = $gruppen{$prog};
        $anz{$path}++;
        my $new = "$path/$film";
        my $str = sprintf('%03d : %s => %s',$i,$film, "C:/Filme/$path/");
        #mkpath($path);
        if ($action eq 'verschieben') {
            move($film, "C:/Filme/$path/");
        }
        else {
            copy($film, "C:/Filme/$path/");
        }
        $txt_lb->insert('end',$str);
        $txt_lb->idletasks();
        $txt_lb->update();
    }
    for my $anz (sort keys %anz) {
        $txt_lb->insert('end', "$anz : $anz{$anz}");
    }
}

sub toggle_action {
    $action = ($action eq 'verschieben') ? 'kopieren' : 'verschieben';
}