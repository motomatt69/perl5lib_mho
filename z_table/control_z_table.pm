package z_table::control_z_table;
use strict;

sub new {
    my($class,$v_main,$model)=@_;
    my %daten=(v_main=>$v_main,
               model=>$model);
    my $obj=bless(\%daten,$class);
    return $obj;
}

sub get_model {
    my ($obj) = @_;
    return $obj->{model}
}
sub get_v_main {
    my ($obj) = @_;
    return $obj->{v_main}
}
    
sub sende {
    my ($obj, $nachricht) = @_;
    print "c_nachricht: $nachricht\n";
    if ($nachricht eq 'main_start') {$obj->_main_start();}
    if ($nachricht eq 'm_AuftragAkt') {$obj->_m_AuftragAkt();}
    if ($nachricht eq 'v_AnrAuswahl') {$obj->_v_AnrAuswahl();}
    if ($nachricht eq 'm_AnrList') {$obj->_m_AnrList();}
    if ($nachricht eq 'v_AnrNeu') {$obj->_v_AuftragNeu();}
    if ($nachricht eq 'm_AnrDat') {$obj->_m_AnrDat();}
    if ($nachricht eq 'm_ZngDat') {$obj->_m_ZngDat();}
}
    
# ab hier private methoden

sub _main_start {
    my ($obj) = @_;
    my $model=$obj->get_model();
    $model->Anr_lesen();
}

sub _m_AuftragAkt {
    my ($obj) = @_;
    
    my $model=$obj->get_model();
    my $anr=$model->get_anr();
    my $anrdat=$model->AnrDat_lesen();
    
    my $v_main=$obj->get_v_main;
    $v_main->set_anr($anr);
    $v_main->set_anrdat($anrdat);
    my $tx_zdat=$v_main->get_zngdat;
    $model->set_zngdat($tx_zdat); 
    $model->ZngDat_lesen();
}

sub _v_AnrAuswahl {
    my ($obj) = @_;
    my $model=$obj->get_model();
    $model->anrlist();
}

sub _m_AnrList {
    my ($obj) = @_;
    my $model=$obj->get_model();
    my$anrlist=$model->get_anrlist();
    my $v_main=$obj->get_v_main;
    $v_main->set_anrlist($anrlist);
    $v_main->anrlist_popup();
}
    
sub _v_AuftragNeu {
    my ($obj) = @_;
    my $v_main=$obj->get_v_main;
    my$anr=$v_main->get_anr;
    my$tx_zdat=$v_main->get_zngdat;
    
    my $model=$obj->get_model();
    $model->set_anr($anr);
    $model->Anr_schreiben();
    $model->AnrDat_lesen();
    $model->set_zngdat($tx_zdat);
    $model->ZngDat_lesen();
    $v_main->change_txt_auf();
}

sub _m_AnrDat {
    my ($obj) = @_;
    my $model=$obj->get_model();
    my $AnrDatRef=$model->get_anrdat();
    my $v_main=$obj->get_v_main;
    $v_main->set_anrdat($AnrDatRef);
    $v_main->change_txt_auf();
}
sub _m_ZngDat {
    my ($obj) = @_;
    my $model=$obj->get_model();
    my $tx_zdat=$model->get_zngdat();
    my $v_main=$obj->get_v_main;
    $v_main->set_zngdat($tx_zdat);
    $v_main->change_tx();
}
1;