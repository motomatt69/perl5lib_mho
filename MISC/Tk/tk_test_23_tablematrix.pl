#!/usr/bin/perl -w
use Tk;
use Tk::TableMatrix;

use strict; use warnings;

my $mw = MainWindow->new;
my $table = $mw->Scrolled("TableMatrix",
                                                  -resizeborders=>'both',
                                                  -titlerows => 1,
                                                  -rows => 20,
                                                  -colstretchmode=>'all',
                                                  -cols => 3,
                                                  -cache => 1,
                                                  -scrollbars => "e");

for(my $row = 1; $row < 20; $row++) {
        my $button = $table->Optionmenu(-options => ["enabled", "disabled"]);
        $table->windowConfigure("$row,5", -window => $button);

}

$table->set("0,0", "Col 1");
$table->set("0,1", "Col 2");
$table->set("0,2", "Col 3");
$table->set("0,3", "Col 4");
$table->set("0,4", "Col 5");

$table->pack(-expand => 1,
                         -fill => 'both');

MainLoop; 