package z_table::v_anrlist_z_table;
use strict;

sub new {
    my($class)=@_;
    my $obj = bless {}, $class;
    my $mw = MainWindow->new();
    $obj->_set_mainwindow ($mw);
    $obj->obj_init();
    return $obj;
}
    
#Oberfläche vom  anlegen
sub obj_init {
    my $obj=shift;
    
    #Hauptfenstereinteilung, Framesanordnung
    my $fo = $obj->get_mainwindow->Frame();
    my $fm = $obj->get_mainwindow->Frame();
    my $fu = $obj->get_mainwindow->Frame();
    
    $fo->grid(-row=>0,-column=>0);
    $fm->grid(-row=>1,-column=>0);
    $fu->grid(-row=>2,-column=>0);
    
    #Auftragsauswahlschalter
    my $bto_aufausw=$fo->Button(-text => 'Auftrag',
                                -command=>sub{$obj->_sende_nachricht('v_AnrAuswahl')},);
    #Auftragsdatenfenster anzeigen
    my $txt_auf=$fo->Text(-height=>6,
                          -width=>60);
    
    $obj->set_txt_auf($txt_auf);
    #Aufhörenschalter
    my $bto_exit =$fo->Button (-text=>"exit",
                               -command=> sub {exit(0)});
    
    #Zeugs anordnen
    $bto_aufausw->grid(-row=>0,-column=>0);
    $txt_auf->grid(-row=>0,-column=>1);
    $bto_exit->grid(-row=>0,-column=>2);
}

1;