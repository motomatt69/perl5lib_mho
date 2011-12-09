use strict;
use warnings;
use Tk;
use Tk::TableMatrix::Spreadsheet;

my $mw = tkinit();

my %table = ();
my $ft = $mw->Scrolled(
    'Spreadsheet',
    -cols           => 8,
    -rows           => 9,
    -variable       => \%table,
    -selectmode     => 'extended',
    -bg             => 'white',
    -bg             =>  'white',
    -scrollbars     => 'se',
);

$ft->set("0,0", 'Test mit breiteeeeeeeeeeeeeeeeem Text');

# Tag für th erstellen, -bg => '#009966',
$ft->tag('celltag', 'th', "0,0", "1,0", "1,4", "2,0", "3,0", "4,0", "5,0", "6,0", "7,0", "8,0", "2,4", "3,4", "4,4", "5,4", "6,4", "7,4", "8,4",);
$ft->tagConfigure('th', -bg => '#009966', -fg => '#FFFFFF', -font => '{Verdana} 10 {bold}' );


# Dokumentation
# $table->spans(?index?, ?rows,cols, index, rows,cols, ...?)

# Zeile 1: Zeit, colspan=8
$ft->spans("0,0", "0,8");

# Zeile 2: 2 * Modus, colspan=4
$ft->spans("1,0", "0,3");
$ft->spans("1,4", "0,3");

# Zeile 3: 2 * (Person,Stamm,ZM,Endung), Stamm,ZM = rowspan=6
$ft->spans("2,1", "6,0");
$ft->spans("2,2", "6,0");
$ft->spans("2,5", "6,0");
$ft->spans("2,6", "6,0");

$ft->pack();

$mw->MainLoop();