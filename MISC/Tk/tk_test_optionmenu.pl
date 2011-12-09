use strict;
use warnings;

use Tk;   
use Tk::Dialog;

my $mw = MainWindow->new();
    
my $bto = $mw->Button(-text => 'Knopf',
                      -command => \&doit)->pack()   ; 

MainLoop;
        
sub doit{
    
    my @choices = qw/eins zwei drei fds wfe wef wef qerg jz jk ghkmgj/;
    
    my $dia = $mw->Dialog(-buttons => ['Abbruch']);
    my $fr = $dia->Subwidget('top');
    
    my $lb = $fr->Scrolled('Listbox',
                           -scrollbars => 'e',
                           -selectmode => 'single',
                          );
    
    $lb->pack();
        
    
    $lb->insert('end', sort @choices);
    $lb->bind('<Double-Button-1>' =>
              sub{
    
        my $val = $lb->get($lb->curselection());
        
        print "Habe fertig $val\n";
        $dia->Exit()});
    $dia->Show()
        
}

