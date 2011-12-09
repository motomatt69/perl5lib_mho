#!/usr/bin/perl -w
use strict;
use Tk;

# Variablendeklaration
my $mw;
my ($mb, $m_file,$m_edit, $m_opts, $m_help);
my ($m_help_about);
my $o_radio=0;
my $o_check1=0;
my $o_check2=0;

$mw = MainWindow->new;


#Horizontale Menubar
$mb=$mw->Frame(-relief => 'ridge',
               -bd => 5);

#Menubuttons für horizontale menubar
$m_file=$mb->Menubutton(-text =>'Datei',
                        -underline=>1); #underline = Buchstabennummer die unterstrichen werden soll 1 = 2ter Buchstabe

$m_edit=$mb->Menubutton(-text =>'Bearbeiten',
                        -underline=>0);

$m_opts=$mb->Menubutton(-text =>'Optionen',
                        -underline=>0);

$m_help=$mb->Menubutton(-text =>'Hilfe',
                        -underline=>0);

#Zeig es uns

$mb->pack(-side=>'top',-fill=>"x");
$m_file->pack(-side=>'left');
$m_edit->pack(-side=>'left');
$m_opts->pack(-side=>'left');
$m_help->pack(-side=>'right');

#Untermenues

#Untermenu Datei
$m_file->command(-label=>'neu',
                 -command=>sub{file("neu")});
$m_file->command(-label=>'öffnen',
                 -command=>sub{file("open")});
$m_file->command(-label=>'speichern',
                 -command=>sub{file("speichern")},
                 -state=>"disabled");#deaktiviert
$m_file->separator();
$m_file->command(-label=>'speichern unter..',
                 -command=>sub{file("speichern unter..")},
                 -state=>"disabled");#deaktiviert
#separator der immer unten Positioniert wird und von den anderen getrennt ist
$m_file->separator();
$m_file->command(-label=>"Exit",
                 -underline =>1,
                 -command => sub {exit 0;});
 
 #Untermenu Bearbeiten
$m_edit->command(-label => 'Kopieren',
                 -command => sub{edit("kopieren")});
$m_edit->command(-label => 'Ausschneiden',
                 -command => sub{edit("ausschneiden")});
$m_edit->command(-label => 'Einfuegen',
                 -command => sub{edit("einfuegen")});

#Optionsmenu
$m_opts->command(-label =>"Ausführen",
                 -command=>sub{opts("ausführen")});

$m_opts->separator();

#Checkboxen und Radiobuttons
$m_opts->checkbutton(-label =>"Check1",
                     -variable =>\$o_check1,
                     -command=>sub{opts('check')});

$m_opts->checkbutton(-label =>"Check2",
                     -variable =>\$o_check2,
                     -command=>sub{opts('check')});

$m_opts->separator();
$m_opts->radiobutton(-label => "Radio 1",
                     -variable=> \$o_radio,
                     -value => "r1",
                     -command=>sub{opts('radio')});
$m_opts->radiobutton(-label => "Radio 2",
                     -variable=> \$o_radio,
                     -value => "r2",
                     -command=>sub{opts('radio')});

#Hilfe Menu
$m_help->command(-label=> "Inhalt",
                 -command=>sub {help('inhalt')});

$m_help->command(-label=> "Hilfe",
                 -command=>sub {help('hilfe')});

$m_help->separator();

#Ein Untermenu im Untermenu
$m_help_about=$m_help->cget(-menu)->Menu();
$m_help->cascade(-label =>"Über...",
                -menu=> $m_help_about);



$m_help_about->command(-label=>"Perl",
                       -command=>sub{about('perl')});
$m_help_about->command(-label=>"Tk",
                       -command=>sub{about('tk')});
$m_help_about->command(-label=>"windows",
                       -command=>sub{about('windows')});
$m_help_about->command(-label=>"C/C++",
                       -command=>sub{about('C/C++')});

MainLoop;
####die callbacks
sub file {
    my ($arg)=@_;
    print $arg;
    my $tw = $mw->Toplevel(-title=>"Datei $arg");
    my $mes=$tw->Message(-text=>"Datei $arg ist nicht aktiv",
                         -width=>'10c',
                         -justify => 'center')->pack(-side => 'top');
    my $but=$tw->Button(-text=>"Schließen",
                        -command=>[$tw=>'destroy'])->pack(-side=>'top');
}
sub edit {
    my ($arg) = @_;
    my $tw=$mw->Toplevel(-title=>"Bearbeitung $arg");
    my $mes=$tw->Message(-text=>"Bearbeitung $arg ist nicht aktiv",
                         -width=>'10c',
                         -justify => 'center')->pack(-side => 'top');
    my $but=$tw->Button(-text=>"Schließen",
                        -command=>[$tw=>'destroy'])->pack(-side=>'top');
}
sub opts {
    my ($arg)=@_;
    print "________________\n";
    print "opts: $arg\n";
    print "radio  : $o_radio\n";
    print "check 1: $o_check1\n";
    print "check 2: $o_check2\n";
}
sub help {
my ($arg) = @_;
    my $tw=$mw->Toplevel(-title=>"Hilfe $arg");
    my $mes=$tw->Message(-text=>"Hilfe $arg ist nicht aktiv",
                         -width=>'10c',
                         -justify => 'center')->pack(-side => 'top');
    my $but=$tw->Button(-text=>"Schließen",
                        -command=>[$tw=>'destroy'])->pack(-side=>'top');
}
sub about {
    my $arg=@_;
    print "about: $arg\n";
}