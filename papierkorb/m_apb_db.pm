package PPEEMS::APB_STL_NC::m_apb_db;
use strict;
use warnings;

use PPEEMS::DB::PPEEMS;
#use PPEEMS::DWG::SHOP::zng2rev_statusbits;
use Moose;
BEGIN {extends 'Patterns::MVC::Model'};
#
has 'cdbh'            => (isa => 'Object',  is => 'ro', required => 0);
has 'dbh'             => (isa => 'Object',  is => 'ro', required => 0);

has 'get_selteilzngpaths' => (isa => 'HashRef',is => 'ro', required => 0);
has 'get_zdata'          => (isa => 'HashRef',is => 'ro', required => 0);
#has 'tpl          '  => (isa => 'ArrayRef',is => 'ro', required => 0);
#has 'teilzngs'       => (isa => 'ArrayRef',is => 'rw', required => 0);
#has 'tzps'           => (isa => 'ArrayRef',is => 'rw', required => 0);
#has 'get_hdfile'         => (isa => 'Str'     ,is => 'rw', required => 0);
#has 'hdtxtvars'      => (isa => 'HashRef' ,is => 'rw', required => 0);
#has 'members_ascii'  => (isa => 'HashRef' ,is => 'rw', required => 0);
#has 'bitm      '     => (isa => 'Object',  is => 'rw', required => 0);
#has 'zdata'          => (isa => 'HashRef', is => 'ro', required => 0);
#has 'apbpos_act'     => (isa => 'Int',     is => 'rw', required => 0);

#
#
sub BUILD{
    my ($self) = @_;
    
    $self->{cdbh} = DB::SWD->new();
    $self->{dbh} = $self->{cdbh}->dbh();
}

sub check_bmf_available{
    my ($self, $hposlsref) = @_;
    
    print "DB Abfrage programmieren\n";
    
    my @selteilzngpaths = ('C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010304_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010560_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010562_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010562_02_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010563_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010563_02_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010564_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010564_02_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010564_03_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010565_01_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010565_02_00.bmf_',
                           'C:\dummy\bmf\tb_zeichnungen\FSP\10062010\hp229005010565_03_00.bmf_',
                          );
    
    my $result = 1;
    
    if ($result == 0){
        $self->throwError('F1', "Zeichnung Nummer fehlt" );   
    }
    
    #%selteilzngpaths = $self->_read_b3dposs2apbposs(%selteilzngpaths);
    $self->{get_selteilzngpaths} = \@selteilzngpaths;
}

sub read_tzdata{
    my ($self, $ts, $hpos, $blatt, $rev) = @_;
    
    my $dbh = $self->{cdbh}->dbh();
    my $sth = $dbh->prepare(qq( SELECT  a.tsnr, a.tsbez, a.ts, c.zng,
                                        c.zngnr, c.zngbez, d.zngtypbez,
                                        f.unitbez, f.gbmy, f.gbral,
                                        f.zbmy, f.zbral, f.dbmy,
                                        f.dbral, g.zng2rev, h.revnr, h.alias,
                                        j.hpos, j.anz, j.bez, l.apbposnr,
					m.konst, m.date, m.indextext, n.blattnr
                                FROM    zz_ts a, zz_zng c,
                                        zz_zngtyp d, zz_zng2unit e, zz_unit f,
                                        zz_zng2rev g, zz_rev h,
                                        zz_hpos j, zz_apbpos l, zz_teilzng m, zz_blatt n
                                
                                WHERE   a.ts = c.ts
                                AND 	a.tsnr = ?
                                AND     c.zngnr = ?
                                AND     c.zngtyp = d.zngtyp
                                AND     c.zng = e.zng
                                AND     e.unit = f.unit
                                AND     c.zng = g.zng
                                AND     g.rev = h.rev
                                AND     h.revnr = ?
                                AND     g.zng2rev = j.zng2rev
                                AND     j.hpos = l.hpos
                                AND	g.teilzng = m.teilzng
                                AND     g.blatt = n.blatt
                                AND     n.blattnr like ?));
    $sth->execute($ts, $hpos, $rev, $blatt);
    my (%zdata, %apbposs);
    while (my $rec = $sth->fetchrow_arrayref()){
            
            %zdata = ( tsnr => $rec->[0], tsbez => $rec->[1], ts_id => $rec->[2],
                        zng_id => $rec->[3], zngnr => $rec->[4], zngbez => $rec->[5],
                        zngtyp => $rec->[6], unit => $rec->[7], gbmy => $rec->[8],
                        gbral => $rec->[9], zbmy => $rec->[10], zbral => $rec->[11],
                        dbmy => $rec->[12], dbral => $rec->[13], zng2rev_id => $rec->[14],
                        revnr => $rec->[15], revalias => $rec->[16],hpos_id => $rec->[17],
                        anz => $rec->[18], profil => $rec->[19],
                        konst => $rec->[21], datum => $rec->[22], indextext => $rec->[23],
                        blatt => $rec->[24]);
            
            $apbposs{$rec->[20]} = undef;
            $zdata{apbposs} = \%apbposs;
    }
    ($zdata{cube}) = $zdata{tsnr} =~ m/\d{3}(\d{3})/;
    
    my $date = $zdata{datum};
    my ($yyyy, $mm, $dd) = $date =~ m/(\d{4})-(\d{2})-(\d{2})/;
    $zdata{datum} = $dd.'.'.$mm.'.'.$yyyy;
    
    $self->{zdata} = \%zdata;
    
    $self->_next_apbzngnr();
    $self->_blattanzahl($ts, $hpos, $blatt, $rev);
}
    
#sub read_zdata_from_db{
#    my ($self) = @_;
#    
#    $self->{get_zdata}{gbmy} = 'xxxmy';
#    $self->{get_zdata}{gbral} = 'RALxxxx';
#    $self->{get_zdata}{zbmy} = 'xxxmy';
#    $self->{get_zdata}{zbral} = 'RALxxxx';
#    $self->{get_zdata}{dbmy} = 'xxxmy';
#    $self->{get_zdata}{dbral} = 'RALxxxx';
#}
#
#sub set_zdata{
#    my ($self, $hdrdat) = @_;
#    
#    $self->{get_zdata}{anr} = $hdrdat->{anr};
#    $self->{get_zdata}{ts} = $hdrdat->{ts};
#    $self->{get_zdata}{tsbez} = $hdrdat->{tsbez};
#    $self->{get_zdata}{date} = $hdrdat->{date};
#    $self->{get_zdata}{user} = $hdrdat->{user};
#    $self->{get_zdata}{weight} = $hdrdat->{weight};
#    $self->{get_zdata}{surface} = $hdrdat->{surface};
#}
#
#sub _read_b3dposs2apbposs{
#    my ($self, %selteilzngpaths) = @_;
#    
#    for my $key (sort keys %selteilzngpaths){
#
#        my ($fn) = $key =~ m/(hp\d{6}0\d{5}_\d{2}_\d{2})\.pdf/;
#        $fn .= '%';
#        
#        my $sth = $self->{dbh}->prepare(qq( SELECT  zngnr, apbposnr, apbnr
#                                            FROM zz_v_gesamt
#                                            WHERE file LIKE ?));
#        $sth->execute($fn);
#        my @recs;
#        while (my @rec = $sth->fetchrow_array()){
#           push @recs,[@rec] 
#        }
#        
#        $selteilzngpaths{$key} = \@recs;
#    }    
#    return %selteilzngpaths;
#}
    
#sub get_single_template{
#    my ($self, $file) = @_;
#    
#    my ($rec) = $self->{cdbh}->zz_vorlagen->search(file => $file );
#    
#    my $f = $rec->file();
#    my $vol = $rec->vol();
#    my $dirs = $rec->dirs();
#    my $path = File::Spec->catpath($vol, $dirs, $f);
#    
#    my $tpl;
#    $tpl->{path} = $path;
#    $tpl->{file} = $rec->file();
#    $tpl->{d0x} = $rec->d0x();
#    $tpl->{d0y} = $rec->d0y();
#    $tpl->{pw}  = $rec->pw();
#    $tpl->{ph}  = $rec->ph();
#    
#    return $self->{tpl} = $tpl;
#}
#
#sub set_sizes{
#    my ($self, $sizes, $table) = @_;
#    
#    for my $size (keys %$sizes){
#        my ($vol, $dirs, $f) = File::Spec->splitpath($size);
#        
#        my $d0x = $sizes->{$size}->{d0x};
#        my $d0y = $sizes->{$size}->{d0y};
#        my $pw  = $sizes->{$size}->{pw};
#        my $ph  = $sizes->{$size}->{ph};
#        
#        my ($rec) = $self->{cdbh}->$table->search(file => $f,
#                                                  vol => $vol,
#                                                  dirs => $dirs);
#        
#        $rec-> d0x($d0x);
#        $rec-> d0y($d0y);
#        $rec-> pw($pw);
#        $rec-> ph($ph);
#        
#        $rec->update();
#    }
#}
#

#
#sub get_frame_sizes{
#    my ($self, $ftype) = @_;
#    
#    my @templates = $self->{cdbh}->zz_vorlagen->search(typ => 'frame',
#                                                       filetype => $ftype);
#    my @a0xfrms = grep {$_->{file} =~ m/frame_a\d{2}/} @templates;
#    @a0xfrms = map{$_->{file}} @a0xfrms;
#    
#    return \@a0xfrms;                       
#}
#
#
#sub _next_apbzngnr{
#    my ($self) = @_;
#    
#    my $cdbh = $self->{cdbh};
#    $cdbh->disableTransactions;
#    my $dbh = $cdbh->dbh();
#    
#    my %zdata = %{$self->{zdata}};
#    
#    for my $key (sort keys %{$zdata{apbposs}}){
#        my $blatt = $zdata{blatt};
#        my $hpos_id = $zdata{hpos_id};
#        my ($apbposrec) = $cdbh->zz_apbpos->find_or_create(apbposnr => $key,
#                                                           apbblattnr => $blatt,
#                                                           hpos => $hpos_id);
#        my $apbzng = $apbposrec->apbzng();
#        
#        if ($apbzng){
#            $self->{zdata}{apbposs}{$key}->{apbzng_id}  = $apbposrec->apbzng();
#        }
#        else{
#            my $tsnr = $zdata{tsnr};
#            my ($bgr) = $tsnr =~ m/(\d{3})\d{3}/;
#            
#            my ($bgrrec) = $cdbh->zz_baugruppe->search(bgrnr => $bgr);
#            my $bgr_id = $bgrrec->baugruppe();
#            
#            my ($apbzngtyp) = $cdbh->zz_apbzngtyp->search(typbez => 'werkstattpläne');
#            my $apbzngtyp_id = $apbzngtyp->apbzngtyp();
#            
#            my $sth = $dbh->prepare(qq( SELECT a.apbzng
#                                        FROM    zz_apbzng a 
#                                        LEFT OUTER JOIN zz_apbpos b ON a.apbzng = b.apbzng
#                                        WHERE a.baugruppe = ?
#                                        AND   a.apbzngtyp = ?
#                                        AND   b.apbpos is null
#                                        ORDER BY a.apbnr
#                                        LIMIT 1));
#            $sth->execute($bgr_id, $apbzngtyp_id);
#            my @apbzng = $sth->fetchrow_array();
#            $self->{zdata}{apbposs}{$key}{apbzng_id} = $apbzng[0];
#            
#            $apbposrec->apbzng($apbzng[0]);
#            $apbposrec->update();
#            
#        }
#        
#        my ($apbzngrec) = $cdbh->zz_apbzng->search(apbzng => $self->{zdata}{apbposs}{$key}{apbzng_id});
#        $self->{zdata}{apbposs}{$key}->{apbnr} = $apbzngrec->apbnr();
#        $self->{zdata}{apbposs}{$key}->{rwenr} = $apbzngrec->rwenr();
#        
#        my $apbfn = $self->{zdata}{apbposs}{$key}->{apbnr};
#        $apbfn =~ s/[\.| ]//g; #punkt leerzeichen raus
#        $apbfn =~ s/\//_/g;#slash durch unterstrich
#        $apbfn =~ s/-/_/g;#minus durch unterstrich
#        $apbfn .= '_'.$zdata{revnr}.'.bmf_'; 
#        $self->{zdata}{apbposs}{$key}->{apbfn} = $apbfn;
#    }
#    
#}
#
#sub _blattanzahl{
#    my ($self, $ts, $hpos, $blatt, $rev) = @_;
#    
#    my $strg = 'hp'.$ts.'0'.$hpos.'%'.$rev.'.bmf_';
#    my ($teilzngrec) = $self->{cdbh}->zz_teilzng->retrieve_from_sql(qq(
#        file LIKE "$strg"
#        order by file desc
#        limit 1));
#       
#    my ($blattanz) = $teilzngrec->file() =~ m/hp\d{6}0\d{5}_(\d{2})_\d{2}\.bmf_/;
#    $self->{zdata}{blattanz} = $blattanz;
#}
##    
##

#sub get_header_headertexts{
#    my ($self, $anr, $headernr) = @_;
#    
#    $self->{hdtxtvars} = ();
#    
#    my $cdbh = $self->{cdbh};
#    my ($auftrag) = $cdbh->zz_auftrag->search(anr => $anr);
#    my $auftrag_id = $auftrag->auftrag();
#    
#    #plankopf_id ermitteln
#    my ($hd_id, $hdtpl_id);
#    my @pk_ids = $cdbh->zz_auftrag2plako->search(auftrag => $auftrag_id);
#    for my $rec (@pk_ids){
#        my ($hd) = $cdbh->zz_plako->search( plako_id => $rec->plako_id(),
#                                            plako_nr => $headernr);
#        if ($hd){
#            $hd_id    = $hd->plako_id();
#            $hdtpl_id = $hd->vorlage_id();
#            last
#        };
#    }
#    #headertemplate
#    my ($tpl) = $self->{cdbh}->zz_vorlagen->search(vorlage_id => $hdtpl_id);
#    my $hdfile = $tpl->file();
#    $self->{hdfile} = $hdfile;
#    
#    #texte zum plankopf ermitteln
#    my @pk2ptxt = $cdbh->zz_plako2plakotext->search(plako_id => $hd_id);
#    if (!@pk2ptxt){return};
#    my @pktxt_ids = map {$_->plakotext_id} @pk2ptxt;
#    my $hdtxt_idlist = join ',',@pktxt_ids;
#     
#    my @hdtxtrecs = $cdbh->zz_plakotext->retrieve_from_sql(qq{plakotext_id in ($hdtxt_idlist)});
#    
#    #textwerte einlesen
#    for my $rec (@hdtxtrecs){
#        my %hdtxt;
#        my ($txtvarrec) = $cdbh->zz_textvariable->search(textvariable_id => $rec->textvariable_id());
#        my $txtvar = $txtvarrec->bez();
#        $hdtxt{var} = $txtvar;
#        
#        my $txtstyle_id = $rec->textstyles_id();
#        
#        $hdtxt{d0x} = $rec->d0x();
#        $hdtxt{d0y} = $rec->d0y();
#        $hdtxt{range} = $rec->range();
#        
#        #print "$txtvar\n";
#        my $sub;
#        $sub = '_search_'.$txtvar;
#        my $can = $self->_checksub($sub);
#        my $val;
#        if ($can ==1) {
#            $val = $self->$sub(\%hdtxt)
#        };
#        if (ref($val) eq 'ARRAY'){
#            my $txtblock_id = $rec->textblock_id();
#            my ($txtblockrec) = $self->{cdbh}->zz_textblock->search(textblock_id => $txtblock_id);
#            my $rows = $txtblockrec->zeilen();
#            my $hgt = $txtblockrec->blockhoehe();
#                       
#            $hdtxt{val} = $self->_textblock_erstellen(\%hdtxt, $txtstyle_id, $rows, $hgt, $val);
#        }
#        else{
#            $hdtxt{val} = $val;
#            %hdtxt = %{$self->_hdtxt2textstyle(\%hdtxt, $txtstyle_id)};
#            $self->{hdtxtvars}{$hdtxt{var}} = \%hdtxt;
#        }
#    }
#}
#
#sub _checksub{
#    my ($self, $sub) = @_;
#    
#    if ($self->can($sub)){
#        return 1       
#    }
#    else{
#        $self->printtrace("sub: $sub nicht angelegt!\n");
#        return 0
#    }
#}
#        
#sub _hdtxt2textstyle{
#    my ($self, $hdtxt, $txtstyle_id) = @_;
#    
#    my ($txtstyletab) = $self->{cdbh}->zz_textstyles->search(textstyles_id => $txtstyle_id);
#    
#    $hdtxt->{winkel}       = $txtstyletab->winkel();
#    $hdtxt->{stift}        = $txtstyletab->stift();
#    $hdtxt->{hoehe}        = $txtstyletab->hoehe();
#    $hdtxt->{hoehe2breite} = $txtstyletab->hoehe2breite();
#    $hdtxt->{art}          = $txtstyletab->art();
#    $hdtxt->{neigung}      = $txtstyletab->neigung();
#    $hdtxt->{anker}        = $txtstyletab->anker();
#    $hdtxt->{rahmen}       = $txtstyletab->rahmen();
#    
#    return $hdtxt;
#}
#
#sub set_apbzng2apbpos{
#    my ($self) = @_;
#    
#    my $cdbh = $self->{cdbh};
#    my $apbpos_act = $self->{apbpos_act};
#    my $blatt = $self->{zdata}{blatt};
#    my $hpos_id = $self->{zdata}{hpos_id};
#    
#    
#    my ($apbposrec) = $cdbh->zz_apbpos->search(apbposnr => $apbpos_act,
#                                               apbblattnr => $blatt,
#                                               hpos => $hpos_id);
#    
#    my $apbzng_id = $self->{zdata}{apbposs}{$apbpos_act}{apbzng_id};
#    $apbposrec->apbzng($apbzng_id);
#    $apbposrec->update();
#}
#
#sub set_eintrag_teilzeichnung_erstellt{
#    my ($self) = @_;
#    
#    my $teilzng = $self->{teilzngs}[0];
#    
#    my ($teilzngrec) = $self->{cdbh}->zz_teilzng->search(file => $teilzng);
#    $teilzngrec->apb_erstellt('*');
#    $teilzngrec->update();
#    
#    $self->notify('listbox_update');
#}
#
#sub get_apbposs2b3dpos{
#    my ($self, $p) = @_;
#    
#    my ($fn) = $p =~ m/(hp\d{6}0\d{5}_\d{2}_\d{2})\.pdf/;
#    $fn .= '%';
#    
#    my $sth = $self->{dbh}->prepare(qq( SELECT  zngnr, apbposnr, apbnr
#                                        FROM zz_v_gesamt
#                                        WHERE file LIKE ?));
#    $sth->execute($fn);
#    my @recs;
#    while (my @rec = $sth->fetchrow_array()){
#       push @recs,[@rec] 
#    }
#    return \@recs;
#}
#
#
#
#sub _search_apb_index_alias{
#    my ($self) = @_;
#    
#    my @alias;
#    $alias[0] = "-A";
#    
#    return \@alias;
#}
#
#sub _search_apb_index_datum{
#    my ($self) = @_;
#    
#    my @datum;
#    $datum[0] = $self->{zdata}{datum};
#        
#    return \@datum;
#}
#
#sub _search_apb_index_gezeichnet{
#    my ($self) = @_;
#    
#    my @zeichner;
#    $zeichner[0] = $self->{zdata}{konst};
#    
#    return \@zeichner;
#}
#
#sub _search_apb_index_geprueft{
#    my ($self) = @_;
#    
#    my @geprueft;
#    $geprueft[0] = "KFE";
#    
#    return \@geprueft
#}
#
#sub _search_apb_index_genehmigt{
#    my ($self) = @_;
#    
#    my @genehmigt;
#    $genehmigt[0] = "FRI";
#    
#    return \@genehmigt
#}
#
#sub _search_apb_index_text{
#    my ($self) = @_;
#    
#    my @text;
#    $text[0] = $self->{zdata}{indextext};
#    
#    return \@text
#}
#
#sub _search_apb_zeichnungstitel{
#    my ($self) = @_;
#    
#    my %zdata = %{$self->{zdata}};
#    my $zngtyp = $zdata{zngtyp};
#    my $blattanz = $zdata{blattanz};
#    my $blatteintrag;
#    if ($blattanz > 1){
#        $blatteintrag = 'Blatt '.$zdata{blatt}.' von '.$zdata{blattanz} 
#    }
#    
#    my $titlestr;
#    if ($zngtyp eq 'hp'){
#        my $unit = $zdata{unit};
#        my $tsbez = $zdata{tsbez};
#        my $apbpos_act = $self->{apbpos_act};
#        my $cube = $zdata{cube};
#        
#        if ($blatteintrag){
#            $titlestr = "UNIT $unit#Kesselhaus Stahlbau#$tsbez #Pos $apbpos_act $blatteintrag  CUBE $cube"
#            }
#        else{
#            $titlestr = "UNIT $unit#Kesselhaus Stahlbau#$tsbez #Pos $apbpos_act  CUBE $cube"
#        }
#    }
#    
#    my @title = reverse (split '#', $titlestr);
#
#    return \@title;
#}
#
#sub _search_apb_zeichnungnr{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{apbnr};
#
#    return $znr;
#}
#
#sub _search_apb_index_aktuell{
#    my ($self) = @_;
#    
#    return $self->{zdata}{revnr};
#}
#
#sub _search_apb_index_aktuell_datum{
#    my ($self) = @_;
#    
#    my $val = $self->{zdata}{datum};;
#    return $val;
#}
#
#sub _search_apb_gezeichnet_datum{
#    my ($self) = @_;
#    
#    my $val = $self->{zdata}{datum};;
#    return $val;
#}
#
#sub _search_apb_gezeichnet_name{
#    my ($self) = @_;
#    
#    my $val = $self->{zdata}{konst};
#    return $val;
#}
#
#sub _search_apb_geprueft_datum{
#    my ($self) = @_;
#    
#    my $val = $self->{zdata}{datum};;
#    return $val;
#}
#
#sub _search_apb_geprueft_name{
#    my ($self) = @_;
#    
#    my $val = 'KFE';
#    return $val;
#}
#
#sub _search_apb_genehmigt_datum{
#    my ($self) = @_;
#    
#    my $val = $self->{zdata}{datum};;
#    return $val;
#}
#
#sub _search_apb_genehmigt_name{
#    my ($self) = @_;
#    
#    my $val = 'FRI';
#    return $val;
#}
#
#sub _search_apb_dwgnr_extern1{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    
#    my ($znr1, $znr2) = $znr =~ m/(\d{4}APB\S+)-(\w{3}\d{4}\d{4})/;
#    
#    my $ind = '-'.$self->{zdata}{revalias};    
#    
#    $znr = $znr1.'-   '.$znr2.' '.$ind;
#    return $znr;
#}
#
#sub _search_apb_massstab1{
#    my ($self) = @_;
#    
#    my $val = '1/10';
#    return $val;
#}
#
#sub _search_apb_massstab2{
#    my ($self) = @_;
#    
#    my $val = '1/15';
#    return $val;
#}
#
#sub _search_apb_format{
#    my ($self) = @_;
#    
#    my $val = 'A0';
#    return $val;
#}
#
#sub _search_apb_kks_function{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    
#    my ($kks) = $znr =~ m/\d{4}APB(\S+)-\w{3}\d{4}\d{4}/;
#
#    return $kks;
#}
#
#sub _search_apb_dcc{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    
#    my ($dcc) = $znr =~ m/\d{4}APB\S+-(\w{3})\d{4}\d{4}/;
#
#    return $dcc;
#}
#
#sub _search_apb_dccno{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    
#    my ($dccno) = $znr =~ m/\d{4}APB\S+-\w{3}(\d{4})\d{4}/;
#
#    return $dccno;
#}
#
#sub _search_apb_dccpage{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    
#    my ($dccpage) = $znr =~ m/\d{4}APB\S+-\w{3}\d{4}(\d{4})/;
#
#    return $dccpage;
#}
#
#sub _search_apb_dccindex{
#    my ($self) = @_;
#    
#    my $ind = '-'.$self->{zdata}{revalias};
#    
#    return $ind;
#}
#
#sub _search_apb_dateiname{
#    my ($self) = @_;
#    
#    my $apbpos_act = $self->{apbpos_act};
#    
#    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
#    chomp $znr;
#    my $ind = '-'.$self->{zdata}{revalias};    
#    
#    my $fileno = $znr.$ind;
#    return $fileno;
#}
#
#sub _search_grundbeschichtung_my{
#    my ($self) = @_;
#    
#    return $self->{zdata}{gbmy};
#}
#
#sub _search_grundbeschichtung_ral{
#    my ($self) = @_;
#    
#    return $self->{zdata}{gbral};
#}
#
#sub _search_zwischenbeschichtung_my{
#    my ($self) = @_;
#    
#    return $self->{zdata}{zbmy};
#}
#
#sub _search_zwischenbeschichtung_ral{
#    my ($self) = @_;
#    
#    return $self->{zdata}{zbral};
#}
#
#sub _search_deckbeschichtung_my{
#    my ($self) = @_;
#    
#    return $self->{zdata}{dbmy};
#}
#
#sub _search_deckbeschichtung_ral{
#    my ($self) = @_;
#    
#    return $self->{zdata}{dbral};
#}
#
#sub _search_apb_skizzenbez{
#    my ($self) = @_;
#    
#    my $unit = $self->{zdata}{unit};
#    my $skbez = 'Eemshaven Block '.$unit;
#    
#    return $skbez;
#}
#
#sub _search_apb_planphase{
#    my ($self) = @_;
#       
#    return 'A';
#}
#
#sub _search_wz_besteller{
#    my ($self) = @_;
#    
#    my $adresse = "Alstom Power Systems GmbH#Stuttgart";
#    my @besteller = grep {$_} reverse (split '#', $adresse);   
#    
#    return \@besteller;
#}
#
#sub _search_wz_bauwerk{
#    my ($self) = @_;
#       
#    my $bauwerkstr = "RWE Power#PP Eemshaven Block A";
#    my @bauwerk = grep {$_} reverse (split '#', $bauwerkstr);
#    
#    return \@bauwerk;
#}
#
#sub _search_wz_auftragnr{
#    my ($self) = @_;
#       
#    return '090408';
#}
#
#sub _search_wz_zeichnungstitel{
#    my ($self) = @_;
#    
#    my $titlestr = "TS 229005#Fertigung Teil 1";
#    my @title = grep {$_} reverse (split '#', $titlestr);
#    
#    return \@title;
#}
#
#sub _search_wz_index{
#    my ($self) = @_;
#    
#    my @index;
#    $index[0] = "00";
#    
#    return \@index;
#}
#
#sub _search_wz_index_text{
#    my ($self) = @_;
#    
#    my @indextext;
#    $indextext[0] = "Ersterstellung";
#    
#    return \@indextext;
#}
#
#sub _search_wz_index_datum{
#    my ($self) = @_;
#    
#    my @indexdat;
#    $indexdat[0] = "16.06.2010";
#    
#    return \@indexdat;
#}
#
#sub _search_wz_index_gezeichnet{
#    my ($self) = @_;
#    
#    my @indexgezeichnet;
#    $indexgezeichnet[0] = "FSP";
#    
#    return \@indexgezeichnet;
#}
#
#sub _search_wz_index_projektleiter{
#    my ($self) = @_;
#    
#    my @indexprojektleiter;
#    $indexprojektleiter[0] = "KFE";
#   
#    return \@indexprojektleiter;
#}
#
#sub _search_wz_zeichnungnr{
#    my ($self) = @_;
#    
#    return '00001'
#}
#
#sub _search_wz_blattnr{
#    my ($self) = @_;
#    
#    return '00'
#}
#
#sub _search_wz_index_aktuell{
#    my ($self) = @_;
#    
#    return '00'
#}
#
#sub _search_wz_massstab{
#    my ($self) = @_;
#    
#    return '1/10/15'
#}
#
#sub _search_wz_format{
#    my ($self) = @_;
#    
#    return 'A0'
#}
#
#sub _search_wz_gezeichnet_name{
#    my ($self) = @_;
#    
#    return 'FSP'
#}
#
#sub _search_wz_gezeichnet_tel{
#    my ($self) = @_;
#    
#    return '-163'
#}
#
#sub _search_wz_gezeichnet_fax{
#    my ($self) = @_;
#    
#    return '1163'
#}
#
#sub _search_wz_gezeichnet_email{
#    my ($self) = @_;
#    
#    return 'springer@wendeler.de'
#}
#
#sub _search_wz_gezeichnet_datum{
#    my ($self) = @_;
#    
#    return '16.06.2010'
#}
#
#sub _search_wz_tabelle{
#    my ($self) = @_;
#    
#    return 'tabelle_einfuegen'
#}
#
#
#sub _textblock_erstellen{
#    my ($self, $hdtxtref, $txtstyle_id, $rows, $hgt, $argsref) = @_;
#    
#    my @args = @$argsref;
#    my $anz = $#args + 1;
#    my %hdtxt = %$hdtxtref;
#    if($anz <= $rows){
#        for my $i (1..$anz){
#            my %hdtxttmp = %hdtxt;
#            $hdtxttmp{val} = $args[$i - 1];
#            $hdtxttmp{d0y} += ($i * $hgt / 10 / $rows) - $hgt / 10 / $rows;
#            %hdtxttmp = %{$self->_hdtxt2textstyle(\%hdtxttmp, $txtstyle_id)};
#            $self->{hdtxtvars}{$hdtxt{var}.'part'.$i} = \%hdtxttmp
#        }
#    }
#    elsif($anz > $rows){
#        my $rest = $anz - $rows - 1;
#        for (my $i = $anz; $i > $rest; $i--){
#        my %hdtxttmp = %hdtxt;
#            $hdtxttmp{val} = $args[$i];
#            $hdtxttmp{d0y} += (($i - $rest) * $hgt / 10 / $rows) - $hgt / 10 / $rows;
#            %hdtxttmp = %{$self->_hdtxt2textstyle(\%hdtxttmp, $txtstyle_id)};
#            $self->{hdtxtvars}{$hdtxt{var}.'part'.$i} = \%hdtxttmp;
#        }
#    }
#    return;
#}
#
sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}    
1;
