package PPEEMS::SHOPDWG_1::controler;
use strict;
use PPEEMS::SHOPDWG_1::apb_hp_bmf;
use PPEEMS::SHOPDWG_1::m_shop_pdf;
use PPEEMS::SHOPDWG_1::m_b3d_imp;
use PPEEMS::SHOPDWG_1::m_ftpliste;

use Patterns::Observer qw(:subject);
use Moose;

has 'view'        => (isa => 'Object', is => 'ro', required => 1);
has 'm_db'        => (isa => 'Object', is => 'ro', required => 1);
has 'apb_hp_bmf'  => (isa => 'Object', is => 'ro', required => 0);
has 'm_shop_pdf'  => (isa => 'Object', is => 'ro', required => 0);
has 'm_b3d_imp'   => (isa => 'Object', is => 'ro', required => 0);
has 'm_ftpliste'  => (isa => 'Object', is => 'ro', required => 0);

sub BUILD{
    my ($self) = @_;
    
    my $m_db = $self->{m_db};
    my $apb_hp_bmf = PPEEMS::SHOPDWG_1::apb_hp_bmf->new('m_db' => $m_db);
    $self->{apb_hp_bmf} = $apb_hp_bmf;
    my $m_shop_pdf = PPEEMS::SHOPDWG_1::m_shop_pdf->new('m_db' => $m_db);
    $self->{m_shop_pdf} = $m_shop_pdf;
    my $m_b3d_imp = PPEEMS::SHOPDWG_1::m_b3d_imp->new();
    $self->{m_b3d_imp} = $m_b3d_imp;
    my $m_ftpliste = PPEEMS::SHOPDWG_1::m_ftpliste->new();
    $self->{m_ftpliste} = $m_ftpliste;
}

sub message{
   my ($self, $message) = @_;
   
    if ($message eq 'teilzngs_holen') {$self->_teilzngs_holen()}
    if ($message eq 'template_sizes') {$self->_template_sizes()}
    if ($message eq 'apb_hp_zng') {$self->_do_apb_hp_zng()}
    if ($message eq 'ascii_lists') {$self->_ascii_lists()}
    if ($message eq 'read_teilzng') {$self->_read_teilzng()}
    if ($message eq 'shop_zng') {$self->_shop_zng()}
    if ($message eq 'ftp_liste') {$self->_ftp_liste()}
    
    if ($message eq 'ende') {$self->view_ende()}
}

sub _teilzngs_holen{
    my ($self) = @_;
    
    $self->{m_db}->get_teilzngs();
    #$self->printtrace("Teilzeichnungen eingelesen\n")
}

sub _template_sizes{
    my ($self) = @_;
    $self->{apb_hp_bmf}->template_sizes();
    $self->printtrace("Template Sizes neu gesetzt\n")
}

sub _do_apb_hp_zng{
    my ($self) = @_;
    
    my @selteilzngs = @{$self->{view}->{selteilzngs}};
    
    my ($anr, $headernr) = ('090477', 1);
    
    for my $selteilzng (@{$self->{view}->{selteilzngs}}){
        my ($ts, $hpos, $blatt, $rev) = $selteilzng =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})\.bmf_/;    
       
        $self->{m_db}->get_tzdata($ts, $hpos, $blatt, $rev);
        my %tzdata = %{$self->{m_db}->zdata()};
        my %apbposs = %{$tzdata{apbposs}};
               
        $self->{apb_hp_bmf}->selteilzng($selteilzng);
        
        for my $key (sort keys %apbposs){
            
            $self->{m_db}->apbpos_act($key);
            $self->{m_db}->get_header_headertexts($anr, $headernr);
            my $hdfile = $self->{m_db}->{hdfile};
            
            $self->{apb_hp_bmf}->apbpos_act($key);
            $self->{apb_hp_bmf}->hdfile($hdfile);
            my $hdtxtvars = $self->{m_db}->{hdtxtvars};
            $self->{apb_hp_bmf}->hdtxtvars($hdtxtvars);
            $self->printtrace("Plankopfinfo eingelesen\n");
            
            my $outfn = $apbposs{$key}->{apbfn};
            $self->{apb_hp_bmf}->outfilename($outfn);        
         
            $self->{apb_hp_bmf}->cube($tzdata{cube});
            $self->{apb_hp_bmf}->nest_bmf();
            
            $self->{m_db}->set_apbzng2apbpos();
            $self->{m_db}->set_eintrag_teilzeichnung_erstellt();
            $self->printtrace("ts: $ts  B3Dpos: ".$tzdata{zngnr}."  APBpos: ".$key."  APBzng: $outfn\n");
            #print "$outfn#$outfn##$key#",$tzdata{tsbez},' Pos ',$key,"#$key###",$apbposs{$key}->{rwenr},"\n";
        }
    }
    $self->notify('listbox_update');
} 

sub _ascii_lists{
    my ($self) = @_;
    
    my $erg = $self->{m_b3d_imp}->import_list();
    if ($erg == 0){
        my $res = $self->{m_b3d_imp}->result();
        if ($res =~ m/^Liste nicht mit/ || $res =~ m/unterschiedlichen Stand/){
            $self->printtrace($res);
            return
        }
        elsif($res =~ m/Doppelte Alstom Positionen/){
            $self->printtrace($res);
            my @manylist = @{$self->{m_b3d_imp}->manylist()};
            map {$self->printtrace("$_\n")} @manylist;
            return
        }
    }
    
    my %members_ascii = %{$self->{m_b3d_imp}->members_ascii()};
    map{my $str = sprintf   "%-3s%-6s %-3s%-6s %-4s%-6s %-5s%-12s %-7s%-10s\n",
                           ("ID:",$members_ascii{$_}->{ident},
                            "TS:",$members_ascii{$_}->{ts},
                            "Pos:",$members_ascii{$_}->{pos},
                            "Kenn:",$members_ascii{$_}->{kenn},
                            "Profil:",$members_ascii{$_}->{profil});
    $self->printtrace($str)
    } keys %members_ascii;
    
    my $res = $self->{m_b3d_imp}->result();
    
    $self->{m_db}->members_ascii(\%members_ascii);
    $self->{m_db}->members_ascii2db();
    
    $self->printtrace("$res\n")
}


sub _read_teilzng{
    my ($self) = @_;
    
    my $tzps = $self->{view}->tzps();
    $self->{m_db}->tzps($tzps);
    my $res = $self->{m_db}->set_teilzng_paths();
    
    $self->printtrace("Teilzeichnungen eingelesen\n");
    $self->notify('listbox_update');
}

sub _shop_zng{
    my ($self) = @_;
    
    my @selteilzngs = @{$self->{view}->{selteilzngs}};
    map {$_ =~ s/bmf_/pdf/} @selteilzngs;
    $self->{m_shop_pdf}->selteilzngs(\@selteilzngs);
    
    my ($anr, $headernr) = ('090477', 2);
    
    $self->{m_db}->get_wzdata();
    my %wzdata = %{$self->{m_db}->zdata()};
    
    $self->{m_db}->get_header_headertexts($anr, $headernr);
    my $hdfile = $self->{m_db}->{hdfile};
    $self->{m_shop_pdf}->hdfile($hdfile);
    
    my $hdtxtvars = $self->{m_db}->{hdtxtvars};
    $self->{m_shop_pdf}->hdtxtvars($hdtxtvars);
    $self->printtrace("Plankopfinfo eingelesen\n");
    
    $self->{m_shop_pdf}->nest_pdf();
    
    $self->printtrace("Werkstattzeichnung geschachtelt\n");
}

sub _ftp_liste{
    my ($self) = @_;
    
    my $konst = 'FSP';
    my $dat = '2010-06-10';
    
    $self->{m_db}->konstrukteur($konst);
    $self->{m_db}->datum($dat);
    
    $self->{m_db}->daten_fuer_ftpliste();
    $self->{m_db}->pfad_fuer_ftp_liste();
    my $ftpliste_ref = $self->{m_db}->ftpliste();
    my $ftplistepfad_ref = $self->{m_db}->ftplistepfad();
    
    $self->{m_ftpliste}->ftpliste($ftpliste_ref);
    $self->{m_ftpliste}->ftplistepfad($ftplistepfad_ref);
    
    $self->{m_ftpliste}->excel_liste_ausschreiben();
    
    $self->printtrace("FTP-Liste erstellt\n");
}

sub view_ende{exit};
 
sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}    
1;