package z_table::v_main_z_table;
use strict;
use Tk;
use Tk::TableMatrix;

sub new {
    my($class)=@_;
    #my $obj=bless({MainWindow=>$mw},$class);
    
    my $obj = bless {}, $class;
    $obj->_set_mainwindow ();
    $obj->obj_init();
    return $obj;
}


#Oberfläche vom Hauptfenster anlegen
sub obj_init {
    my $obj=shift;
    
    #Hauptfenstereinteilung, Framesanordnung
    $obj->get_mainwindow->gridColumnconfigure(0,-minsize => 1500, -weight => 1);
    $obj->get_mainwindow->gridRowconfigure(0, -minsize => 128, -weight => 0);
    $obj->get_mainwindow->gridRowconfigure(1, -minsize => 640, -weight => 1);
    $obj->get_mainwindow->gridRowconfigure(2, -minsize => 32, -weight => 0);
    
    my $fo = $obj->get_mainwindow->Frame(-relief => 'sunken', -borderwidth => 5);
    my $fm = $obj->get_mainwindow->Frame(-relief => 'groove', -borderwidth => 5);
    my $fu = $obj->get_mainwindow->Frame(-relief => 'sunken', -borderwidth => 5);
    
    $fo->grid(-row=>0,-column=>0, -sticky => 'nsew');
    $fm->grid(-row=>1,-column=>0, -sticky => 'nsew');
    $fu->grid(-row=>2,-column=>0, -sticky => 'nsew');
    
    $fm->gridColumnconfigure(0, -minsize => 1500, -weight => 1);
    $fm->gridRowconfigure(0, -minsize => 640, -weight => 1);
    
    #Auftragsauswahlschalter
    my $bto_aufausw=$fo->Button(-text => "Auftrag\nwechseln",
                                -width => 8,
                                -command=>sub{$obj->_sende_nachricht('v_AnrAuswahl')},);
    #Auftragsdatenfenster anzeigen
    my $txt_auf=$fo->Text(-height=>8,
                          -width=>60);
    
    $obj->set_txt_auf($txt_auf);
    #Aufhörenschalter
    my $bto_exit =$fo->Button (-text=>"exit",
                               -width => 8,
                               -command=> sub {exit(0)});
    
    #Datentabelle
    my $tx=$fm->Scrolled('TableMatrix', -scrollbars => 'se',
                                        #-width => 0,
                                        );
    
    my  $tx_zdat -> {'0,0'} = 'Typ';    #0
        $tx_zdat -> {'0,1'} = 'Zng-Nr';     #1
        $tx_zdat -> {'0,2'} = 'Blatt';      #2
        $tx_zdat -> {'0,3'} = 'Index';      #3
        $tx_zdat -> {'0,4'} = 'Benennung';  #4
        $tx_zdat -> {'0,5'} = 'Index-Text'; #5
        $tx_zdat -> {'0,6'} = 'M 1:x';    #6
        $tx_zdat -> {'0,7'} = 'Format';     #7
        $tx_zdat -> {'0,8'} = 'Anstrich';   #8
        $tx_zdat -> {'0,9'} = 'Datum';      #9
        $tx_zdat -> {'0,10'} = 'Konst';     #10
        $tx_zdat -> {'0,11'} = 'id';        #11
    
    
    $tx->configure( -cols   => 12,
                    -rows   => 3,
                    -maxwidth => $fm->screenwidth,
                    -maxheight => $fm->screenheight,
                    -titlerows => 1,
                    -anchor=>'w',
                    -background => "white",
                    -rowtagcommand => sub { return rowSub(@_, $tx_zdat) },
                    -colstretchmode => 'unset',
		    -rowstretchmode => 'none',
                    -variable => $tx_zdat,);
    $tx->colWidth(0 => -25, 1 => -50, 2 => -25, 3 => -25, #4 => -400,
                      5 => -250, 6 => -75, 7 => -50, 8 => -175, 9 => -75,
                      10 => -75, 11 => -75);
        

    $tx->tagConfigure('ue_row', -bg => 'yellow', -fg => 'black');
    $tx->tagConfigure('blt01_row', -bg => 'orange', -fg => 'black');
    
    
    $obj->set_tx($tx);
    $obj->set_zngdat($tx_zdat);

#Zeugs anordnen im fo
    $bto_aufausw->grid(-row => 0, -column => 0, -sticky => 'w');
    $bto_exit->grid(-row => 2, -column => 0);
    $txt_auf->grid(-row => 0, -rowspan => 3, -column=>1);
    
#Zeugs anordnen im fm
    $tx->grid(-row=>0, -column=>0, -sticky=>"nsew");
}

sub rowSub{
	my $row = shift;
        my $tx_zdat = shift;
	return "ue_row" if( $tx_zdat->{"$row,0"} eq 'ue');
        return "blt01_row" if( $tx_zdat->{"$row,2"} eq '01');
}





#SetGet Controller
sub set_controler {
    my ($obj, $controler_obj) = @_;
    $obj->{controler} = $controler_obj;
}
sub get_controler {
    my ($obj) = @_;
    return $obj->{controler};
}
#SetGet MainWindow
sub _set_mainwindow {
    my ($obj)=@_;
    my $mw=MainWindow->new;
    $mw->geometry("1500x800+32+32"); #Verhältnis 16:9 = 1,777
    $mw->minsize(1500,800);
    $obj->{MainWindow} = $mw;
}
sub get_mainwindow {
    my $obj=shift;
    return $obj->{'MainWindow'}
}
#SetGet für Auftragstextbox
sub set_txt_auf {
    my ($obj,$txt_auf) = @_;
    $obj->{txt_auf}=$txt_auf
}
sub get_txt_auf {
    my ($obj) = @_;
    return $obj->{txt_auf}
}
#SetGet für Zeichnungsdatentabelle
sub set_tx {
    my ($obj,$tx) = @_;
    $obj->{tx}=$tx
}
sub get_tx {
    my ($obj) = @_;
    return $obj->{tx}
}
#SetGet für Auftragsnummer
sub set_anr {
    my ($obj,$anr) = @_;
    $obj->{anr}=$anr;
    print "v_main: ", $anr, "\n";
}
sub get_anr {
    my ($obj)=@_;
    return $obj->{anr}
}


sub _sende_nachricht {
    my ($obj, $nachricht) = @_;
    my $cont=$obj->get_controler();
    $cont-> sende($nachricht)
}


#Auftragsliste#################################################################
sub anrlist_popup {
    my ($obj)=@_;
    my $AnrListRef=$obj->get_anrlist();
    my $anr=$obj->get_anr();
    
    my $popup=$obj->get_mainwindow->Toplevel;
    
    my $lbx = $popup->Scrolled('Listbox',
                                -height=>32,
                                -width=>64,
                                -scrollbars=>'e',
                                -selectmode=>'single')->pack;
    $popup->configure(-title=>'Auftragsauswahl');
    $lbx->insert('end',@$AnrListRef);
#Selection auf letzten Auftrag setzen    
    my $lbxIndex=0;
    foreach $_ (@$AnrListRef) {
        if ((index $_, $anr) >= 0) {
            last;
        }
        $lbxIndex+=1;
    }
    $lbx->selectionSet ($lbxIndex);
    $lbx->see ($lbxIndex);
#Gewählten Auftrag auslesen und abspeichern        
    $lbx->bind('<Button-1>',
           sub {my @sel=$lbx->curselection();
                $anr=$$AnrListRef[$sel[0]];#Auftrag 
                $anr=~s/^(\d+)  .*$/$1/;#Auftragsnummer von Bezeichnung trennen
                $obj-> set_anr ($anr);#gewählter Auftrag im v_main Objekt setzen
                });
#Listbox wieder abschalten, Auftragsdaten aktualisieren
    my $bto_Ok=$popup->Button(-text=>'ok',
                              -command=> sub { $obj->_sende_nachricht('v_AnrNeu');
                                               $popup->destroy if Tk::Exists($popup)})->pack;
}

#SetGet für Auftragsliste
sub set_anrlist {
    my ($obj,$anrlist) = @_;
    $obj->{anrlist}=$anrlist;
}
sub get_anrlist {
    my ($obj)=@_;
    return $obj->{anrlist}
}    

# Auftragsfenster##############################################################
# Auftragsanzeigefenster aktualisieren
sub change_txt_auf {
    my ($obj) = @_;
    my $txt_auf = $obj->get_txt_auf();
    my $AnrDatRef = $obj->get_anrdat();
    $txt_auf->delete("1.0",'end');#Erstmal alles löschen
    $txt_auf->insert('end', "Auftrag: $AnrDatRef->{'anr'}\n",[],
                            "Auftraggeber: $AnrDatRef->{'ag'}\n",[],
                            "Architekt: $AnrDatRef->{'arch'}\n",[],
                            "Projekt: $AnrDatRef->{'bez'}\n",[],
                            "Projektleiter: $AnrDatRef->{'pl'}\n",[],
                            "Teilsysteme: $AnrDatRef->{'ts'}\n",[],
                            "Blätter gesamt: $AnrDatRef->{'anzblt'}\t",[],
                            "ohne Index: $AnrDatRef->{'anzblt_no_ind'}  ",[],
                            "mit Index: $AnrDatRef->{'anzblt_ind'}",[],
                            );
}

#SetGet für Auftragsdaten
sub set_anrdat {
    my ($obj,$AnrDatRef) = @_;
    $obj->{anrdat}=$AnrDatRef;
}
sub get_anrdat {
    my ($obj)=@_;
    return $obj->{anrdat}
}

# Zeichnungsdatentabelle##############################################################
# Zeichnungsdatentabelle aktualisieren
sub change_tx {
    my ($obj) = @_;
    my $tx = $obj->get_tx();
    my $tx_zdat = $obj->get_zngdat();
    my $rows = delete $tx_zdat->{rows}; 
    
    #print "v_main Zeichnungsdaten in: $rows Reihen\n";
    #foreach my $i (0..$rows) {
    #    print "$i: ",$tx_zdat->{"$i,0"},"\t\t";
    #    print "$i: ",$tx_zdat->{"$i,1"},"\t\t";
    #    print "$i: ",$tx_zdat->{"$i,2"},"\t\t";
    #    print "$i: ",$tx_zdat->{"$i,3"},"\n";
    #}
   
    $tx->configure(-rows => $rows+1);
    $tx->update();
}

#SetGet für Zeichnungsdaten
sub set_zngdat {
    my ($obj, $tx_zdat) = @_;
    $obj->{zngdat} = $tx_zdat;
}
sub get_zngdat {
    my ($obj)=@_;
    return $obj->{zngdat}
}    
1;