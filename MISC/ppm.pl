use strict;
use warnings;

my %moduls = ('class-dbi' => 0,
              'class-dbi-abstractsearch' => 0,
              'moose' => 0,
              'Tk' => 0,
              'Tk-DynaTabFrame' => 0,
              'Tk-ToolBar' => 0,
              'Sort-Versions' => 0,
              'Data-UUID' => 0,
              'Tk-GBARR' => 0,
              'Crypt-PasswdMD5' => 0,
              'Tk-TableMatrix' => 0,
              'Sys-Hostname-Long' => 0,
              'Compress-LZF' => 0,
              'File-Slurp' => 0,
              'Math-Polygon' => 0,
              'Spreadsheet-WriteExcel' => 0,
              'Spreadsheet-ParseExcel' => 0,
              'Tk-DateEntry' => 0,
              'MIME-tools' => 0,
              'Mail-IMAPClient' => 0,
              'Tk-Chart' => 0,
              'Tk-Mk' => 0,
              'DBD-mysql' => 0,
              'Email-Sender' => 0,
              'pdf-API2' => 0,
              'CAM-PDF' => 0,
              'Net-FTP-File' => 1
              );

for my $key (sort keys %moduls){
    next if ($moduls{$key} == 0);
    my $str = "ppm install $key -force";
    print "\n$str\n";
    system $str || die "system $str Fehler: $?";
}

print "fertig\n";