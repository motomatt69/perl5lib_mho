package PPEEMS::SHOPDWG_1::m_db;
use strict;
use warnings;
use Patterns::Observer qw(:subject);
use PPEEMS::SHOPDWG_1::zng2rev_statusbits;
use Moose;

has 'cdbh'           => (isa => 'Object',  is => 'ro', required => 1);
has 'dbh'            => (isa => 'Object',  is => 'ro', required => 1);
has 'tpl_bmf_paths'  => (isa => 'ArrayRef',is => 'ro', required => 0);
has 'tpl          '  => (isa => 'ArrayRef',is => 'ro', required => 0);
has 'teilzngs'       => (isa => 'ArrayRef',is => 'rw', required => 0);
has 'tzps'           => (isa => 'ArrayRef',is => 'rw', required => 0);
has 'hdfile'         => (isa => 'Str'     ,is => 'rw', required => 0);
has 'hdtxtvars'      => (isa => 'HashRef' ,is => 'rw', required => 0);
has 'members_ascii'  => (isa => 'HashRef' ,is => 'rw', required => 0);
has 'bitm      '     => (isa => 'Object',  is => 'rw', required => 0);
has 'zdata'          => (isa => 'HashRef', is => 'ro', required => 0);
has 'apbpos_act'     => (isa => 'Int',     is => 'rw', required => 0);
has 'konstrukteur'   => (isa => 'Str'     ,is => 'rw', required => 0);
has 'datum'          => (isa => 'Str'     ,is => 'rw', required => 0);
has 'ftpliste'       => (isa => 'ArrayRef',is => 'rw', required => 0);
has 'ftplistepfad'   => (isa => 'ArrayRef',is => 'rw', required => 0);


sub BUILD{
    my ($self) = @_;
    
    $self->{bitm} = PPEEMS::SHOPDWG_1::zng2rev_statusbits->new();
}
 
sub get_all_template_bmf_paths{
    my ($self) = @_;
    
    my @recs = $self->{cdbh}->zz_vorlagen->search(  filetype => 'bmf_');
    
    my @tpl_bmf_paths = map {File::Spec->catpath($_->vol(), $_->dirs(), $_->file())} @recs;
    
    return $self->{tpl_bmf_paths} = \@tpl_bmf_paths;
}

sub get_single_template{
    my ($self, $file) = @_;
    
    my ($rec) = $self->{cdbh}->zz_vorlagen->search(file => $file );
    
    my $f = $rec->file();
    my $vol = $rec->vol();
    my $dirs = $rec->dirs();
    my $path = File::Spec->catpath($vol, $dirs, $f);
    
    my $tpl;
    $tpl->{path} = $path;
    $tpl->{file} = $rec->file();
    $tpl->{d0x} = $rec->d0x();
    $tpl->{d0y} = $rec->d0y();
    $tpl->{pw}  = $rec->pw();
    $tpl->{ph}  = $rec->ph();
    
    return $self->{tpl} = $tpl;
}

sub set_sizes{
    my ($self, $sizes, $table) = @_;
    
    for my $size (keys %$sizes){
        my ($vol, $dirs, $f) = File::Spec->splitpath($size);
        
        my $d0x = $sizes->{$size}->{d0x};
        my $d0y = $sizes->{$size}->{d0y};
        my $pw  = $sizes->{$size}->{pw};
        my $ph  = $sizes->{$size}->{ph};
        
        my ($rec) = $self->{cdbh}->$table->search(file => $f,
                                                  vol => $vol,
                                                  dirs => $dirs);
        
        $rec-> d0x($d0x);
        $rec-> d0y($d0y);
        $rec-> pw($pw);
        $rec-> ph($ph);
        
        $rec->update();
    }
}

sub get_teilzngs{ #um Listbox zu füllen
    my ($self) = @_;
    
    my @zz_teilzngs = $self->{cdbh}->zz_teilzng->retrieve_from_sql(qq(filetype like 'bmf_'
                                                                   ORDER BY file));
    my @teilzngs = map{$_->apb_erstellt.'#'.$_->konst.'#'.$_->date.'#'.$_->file} @zz_teilzngs;
    
    $self->{teilzngs} = \@teilzngs;
    $self->notify('teilzngs')
}

sub set_teilzng_paths{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    $cdbh->enableTransactions;
    
    for my $p (@{$self->{tzps}}){
        my ($v, $d, $f) = File::Spec->splitpath($p);
        my ($konst, $dd, $mm, $yyyy) = $d =~ m!tb_zeichnungen/(\w{3})/(\d{2})(\d{2})(\d{4})!;
        my $date = $yyyy.'-'.$mm.'-'.$dd;
        my ($ts, $hpos, $bl, $rev, $ftype) = $f =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})\.(bmf_)/;
        eval{
            #ts
            my ($ts_rec) = $cdbh->zz_ts->search(tsnr => $ts);
            my $ts_id = $ts_rec->ts();
            #blatt
            my ($blattrec) = $cdbh->zz_blatt->find_or_create({blattnr => $bl});
            
            my $blattnr = $blattrec->blattnr();
            my $blatt_id = $blattrec->blatt();
            
            #rev
            my ($revrec) = $cdbh->zz_rev->search(revnr => $rev);
            my $rev_id = $revrec->rev();
            #zng
            my ($zngrec) = $cdbh->zz_zng->search(zngnr => $hpos,
                                                 ts => $ts_id);
            my $zng_id = $zngrec->zng();
            #teilzeichnung
            my ($teilzngrec) = $cdbh->zz_teilzng->find_or_create(file => $f);
            $teilzngrec->filetype($ftype);
            $teilzngrec->vol($v);
            $teilzngrec->dirs($d);
            $teilzngrec->konst($konst);
            $teilzngrec->date($date);
            if ($bl eq '01'){
                $teilzngrec->indextext('First Issue / Ersterstellung')
            }
            $teilzngrec->update();
            
            my $teilzng_id = $teilzngrec->teilzng();
            
            #zng2rev
            my ($zng2rev) = $cdbh->zz_zng2rev->find_or_create(zng => $zng_id,
                                                            rev => $rev_id,
                                                            blatt => $blatt_id);
            my $zng2rev_id = $zng2rev->zng2rev();
            #Bit setzen
            my $val = $zng2rev->status();
            $self->{bitm}->readValue($val);
            $self->{bitm}->setBit('TeilZng');
            my $str = $self->{bitm}->writeValue();
            $zng2rev->status($str);
            $zng2rev->teilzng($teilzng_id);
            $zng2rev->update();
            
            #ggf weiterer hpos eintrag bei mehreren Blättern
            if ($blattnr > 1){
                my ($hposrec) = $cdbh->zz_hpos->search(hposnr => $hpos);
                my $anz = $hposrec->anz();
                my $bez = $hposrec->bez();
                
                my ($hposrecneu) = $cdbh->zz_hpos->find_or_create(hposnr => $hpos,
                                                                  anz => $anz,
                                                                  bez => $bez,
                                                                  zng2rev => $zng2rev_id);
            }
        };
        if ($@){
            print "$@\n";
            eval {$cdbh->rollback();}
        }
        else{
            $self->printtrace("Eintrag in DB: Teilzeichnung $f\n");
            $cdbh->commit();
        }
    }
    $cdbh->enableTransactions;
    
    
}

sub get_teilzng_paths{
    my ($self) = @_;
    
    my @paths;
    for my $teilzng (@{$self->{teilzngs}}){
        my ($rec) = $self->cdbh->zz_teilzng->search(file => $teilzng);
        my $path = File::Spec->catpath($rec->vol(), $rec->dirs(), $teilzng);
    
        push @paths, $path;
    }
    return \@paths;
}

sub get_frame_sizes{
    my ($self, $ftype) = @_;
    
    my @templates = $self->{cdbh}->zz_vorlagen->search(typ => 'frame',
                                                       filetype => $ftype);
    my @a0xfrms = grep {$_->{file} =~ m/frame_a\d{2}/} @templates;
    @a0xfrms = map{$_->{file}} @a0xfrms;
    
    return \@a0xfrms;                       
}

sub get_tzdata{
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

sub _next_apbzngnr{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    $cdbh->disableTransactions;
    my $dbh = $cdbh->dbh();
    
    my %zdata = %{$self->{zdata}};
    
    for my $key (sort keys %{$zdata{apbposs}}){
        my $blatt = $zdata{blatt};
        my $hpos_id = $zdata{hpos_id};
        my ($apbposrec) = $cdbh->zz_apbpos->find_or_create(apbposnr => $key,
                                                           apbblattnr => $blatt,
                                                           hpos => $hpos_id);
        my $apbzng = $apbposrec->apbzng();
        
        if ($apbzng){
            $self->{zdata}{apbposs}{$key}->{apbzng_id}  = $apbposrec->apbzng();
        }
        else{
            my $tsnr = $zdata{tsnr};
            my ($bgr) = $tsnr =~ m/(\d{3})\d{3}/;
            
            my ($bgrrec) = $cdbh->zz_baugruppe->search(bgrnr => $bgr);
            my $bgr_id = $bgrrec->baugruppe();
            
            my ($apbzngtyp) = $cdbh->zz_apbzngtyp->search(typbez => 'werkstattpläne');
            my $apbzngtyp_id = $apbzngtyp->apbzngtyp();
            
            my $sth = $dbh->prepare(qq( SELECT a.apbzng
                                        FROM    zz_apbzng a 
                                        LEFT OUTER JOIN zz_apbpos b ON a.apbzng = b.apbzng
                                        WHERE a.baugruppe = ?
                                        AND   a.apbzngtyp = ?
                                        AND   b.apbpos is null
                                        ORDER BY a.apbnr
                                        LIMIT 1));
            $sth->execute($bgr_id, $apbzngtyp_id);
            my @apbzng = $sth->fetchrow_array();
            $self->{zdata}{apbposs}{$key}{apbzng_id} = $apbzng[0];
            
            $apbposrec->apbzng($apbzng[0]);
            $apbposrec->update();
            
        }
        
        my ($apbzngrec) = $cdbh->zz_apbzng->search(apbzng => $self->{zdata}{apbposs}{$key}{apbzng_id});
        $self->{zdata}{apbposs}{$key}->{apbnr} = $apbzngrec->apbnr();
        $self->{zdata}{apbposs}{$key}->{rwenr} = $apbzngrec->rwenr();
        
        my $apbfn = $self->{zdata}{apbposs}{$key}->{apbnr};
        $apbfn =~ s/[\.| ]//g; #punkt leerzeichen raus
        $apbfn =~ s/\//_/g;#slash durch unterstrich
        $apbfn =~ s/-/_/g;#minus durch unterstrich
        $apbfn .= '_'.$zdata{revnr}.'.bmf_'; 
        $self->{zdata}{apbposs}{$key}->{apbfn} = $apbfn;
    }
    
}

sub _blattanzahl{
    my ($self, $ts, $hpos, $blatt, $rev) = @_;
    
    my $strg = 'hp'.$ts.'0'.$hpos.'%'.$rev.'.bmf_';
    my ($teilzngrec) = $self->{cdbh}->zz_teilzng->retrieve_from_sql(qq(
        file LIKE "$strg"
        order by file desc
        limit 1));
       
    my ($blattanz) = $teilzngrec->file() =~ m/hp\d{6}0\d{5}_(\d{2})_\d{2}\.bmf_/;
    $self->{zdata}{blattanz} = $blattanz;
}
    

sub get_wzdata{
    my ($self) = @_;
    
    $self->{zdata}{gbmy} = '500my';
    $self->{zdata}{gbral} = 'RAL2000';
    $self->{zdata}{zbmy} = '990my';
    $self->{zdata}{zbral} = 'RAL3000';
    $self->{zdata}{dbmy} = '23my';
    $self->{zdata}{dbral} = 'RAL8000';
    
}
sub get_header_headertexts{
    my ($self, $anr, $headernr) = @_;
    
    $self->{hdtxtvars} = ();
    
    my $cdbh = $self->{cdbh};
    my ($auftrag) = $cdbh->zz_auftrag->search(anr => $anr);
    my $auftrag_id = $auftrag->auftrag();
    
    #plankopf_id ermitteln
    my ($hd_id, $hdtpl_id);
    my @pk_ids = $cdbh->zz_auftrag2plako->search(auftrag => $auftrag_id);
    for my $rec (@pk_ids){
        my ($hd) = $cdbh->zz_plako->search( plako_id => $rec->plako_id(),
                                            plako_nr => $headernr);
        if ($hd){
            $hd_id    = $hd->plako_id();
            $hdtpl_id = $hd->vorlage_id();
            last
        };
    }
    #headertemplate
    my ($tpl) = $self->{cdbh}->zz_vorlagen->search(vorlage_id => $hdtpl_id);
    my $hdfile = $tpl->file();
    $self->{hdfile} = $hdfile;
    
    #texte zum plankopf ermitteln
    my @pk2ptxt = $cdbh->zz_plako2plakotext->search(plako_id => $hd_id);
    if (!@pk2ptxt){return};
    my @pktxt_ids = map {$_->plakotext_id} @pk2ptxt;
    my $hdtxt_idlist = join ',',@pktxt_ids;
     
    my @hdtxtrecs = $cdbh->zz_plakotext->retrieve_from_sql(qq{plakotext_id in ($hdtxt_idlist)});
    
    #textwerte einlesen
    for my $rec (@hdtxtrecs){
        my %hdtxt;
        my ($txtvarrec) = $cdbh->zz_textvariable->search(textvariable_id => $rec->textvariable_id());
        my $txtvar = $txtvarrec->bez();
        $hdtxt{var} = $txtvar;
        
        my $txtstyle_id = $rec->textstyles_id();
        
        $hdtxt{d0x} = $rec->d0x();
        $hdtxt{d0y} = $rec->d0y();
        $hdtxt{range} = $rec->range();
        
        #print "$txtvar\n";
        my $sub;
        $sub = '_search_'.$txtvar;
        my $can = $self->_checksub($sub);
        my $val;
        if ($can ==1) {
            $val = $self->$sub(\%hdtxt)
        };
        if (ref($val) eq 'ARRAY'){
            my $txtblock_id = $rec->textblock_id();
            my ($txtblockrec) = $self->{cdbh}->zz_textblock->search(textblock_id => $txtblock_id);
            my $rows = $txtblockrec->zeilen();
            my $hgt = $txtblockrec->blockhoehe();
                       
            $hdtxt{val} = $self->_textblock_erstellen(\%hdtxt, $txtstyle_id, $rows, $hgt, $val);
        }
        else{
            $hdtxt{val} = $val;
            %hdtxt = %{$self->_hdtxt2textstyle(\%hdtxt, $txtstyle_id)};
            $self->{hdtxtvars}{$hdtxt{var}} = \%hdtxt;
        }
    }
}

sub _checksub{
    my ($self, $sub) = @_;
    
    if ($self->can($sub)){
        return 1       
    }
    else{
        $self->printtrace("sub: $sub nicht angelegt!\n");
        return 0
    }
}
        
sub _hdtxt2textstyle{
    my ($self, $hdtxt, $txtstyle_id) = @_;
    
    my ($txtstyletab) = $self->{cdbh}->zz_textstyles->search(textstyles_id => $txtstyle_id);
    
    $hdtxt->{winkel}       = $txtstyletab->winkel();
    $hdtxt->{stift}        = $txtstyletab->stift();
    $hdtxt->{hoehe}        = $txtstyletab->hoehe();
    $hdtxt->{hoehe2breite} = $txtstyletab->hoehe2breite();
    $hdtxt->{art}          = $txtstyletab->art();
    $hdtxt->{neigung}      = $txtstyletab->neigung();
    $hdtxt->{anker}        = $txtstyletab->anker();
    $hdtxt->{rahmen}       = $txtstyletab->rahmen();
    
    return $hdtxt;
}

sub members_ascii2db{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    $cdbh->enableTransactions;
    
    my %members_ascii = %{$self->{members_ascii}};
    for my $key (sort keys %members_ascii){
        my $apbpos = $members_ascii{$key}->{kenn};
        if ($apbpos !~ m/\d{4}-\d{4}/){
            next
        }
        $apbpos =~ s/-//g;
        
        my $b3dpos = $members_ascii{$key}->{pos};
        my $bez    = $members_ascii{$key}->{profil};
        my $anz    = $members_ascii{$key}->{tsqt};
        my $ts     = $members_ascii{$key}->{ts};
        
        if ($ts =~ 220180 or $ts =~ 220190 or $ts =~ 220200 or $ts =~ 220210 or $ts =~ 220220
            or $ts =~ 229005 or $ts =~ 222200){
            eval{
                #auftrag
                my ($auftragrec) = $cdbh->zz_auftrag->search(anr => '090477');
                my $auftrag_id = $auftragrec->auftrag();
                
                #teilsystem
                my ($tsrec) = $cdbh->zz_ts->search(tsnr => $ts);
                if (!$tsrec) {
                    $self->printtrace("Teilsystem $ts noch anlegen\n");
                }
                my $ts_id = $tsrec->ts();
                
                #auftrag2teilsystem
                my ($auftrag2tsrec) = $cdbh->zz_auftrag2ts->find_or_create({auftrag => $auftrag_id,
                                                                            ts => $ts_id});
                
                #zeichnungstyp
                my ($zngtyprec) = $cdbh->zz_zngtyp->search(zngtypbez => 'hp');
                my $zngtyp_id = $zngtyprec->zngtyp();
                
                #zeichnung
                my ($zngrec) = $cdbh->zz_zng->find_or_create({zngnr => $b3dpos,
                                                              zngtyp => $zngtyp_id,
                                                              ts => $ts_id});
                $zngrec->zngbez($bez);
                $zngrec->update();
                my $zng_id = $zngrec->zng();
                
                    
                
                #unit
                my ($unitrec) = $cdbh->zz_unit->search(unitbez => 'A');
                my $unit_id = $unitrec->unit();
                
                #zeichnung2unit
                my ($zng2unit) = $cdbh->zz_zng2unit->find_or_create({zng => $zng_id,
                                                                    unit => $unit_id});
                
                #revision
                my ($revrec) = $cdbh->zz_rev->find_or_create({revnr => '00',
                                                              alias => 'A'});
                my $rev_id = $revrec->rev();
                
                #zeichnung2revision
                my ($zng2revrec) = $cdbh->zz_zng2rev->find_or_create({zng => $zng_id,
                                                                      rev => $rev_id,
                                                                      blatt => 5});
                my $zng2rev_id = $zng2revrec->zng2rev();
                
                #Bitsetzen
                $self->{bitm}->setBit('b3d2apbListe');
                my $str = $self->{bitm}->writeValue();
                $zng2revrec->status($str);
                $zng2revrec->update();
                
                #hauptposition
                my ($hposrec) = $cdbh->zz_hpos->find_or_create({hposnr => $b3dpos,
                                                                zng2rev => $zng2rev_id});
                $hposrec->anz($anz);
                $hposrec->bez($bez);
                $hposrec->update();
                my $hpos_id = $hposrec->hpos();
                
                
                #alstomposition
                my ($apbposrec) = $cdbh->zz_apbpos->find_or_create({apbposnr => $apbpos,
                                                                    hpos => $hpos_id});
                
            };
            if ($@){
                print "$@\n";
                eval {$cdbh->rollback();}
            }
            else{
                $self->printtrace("Eintrag in DB: $b3dpos    $apbpos\n");
                $cdbh->commit();
            }
        }
    }
    $cdbh->disableTransactions;
}

sub set_apbzng2apbpos{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    my $apbpos_act = $self->{apbpos_act};
    my $blatt = $self->{zdata}{blatt};
    my $hpos_id = $self->{zdata}{hpos_id};
    
    
    my ($apbposrec) = $cdbh->zz_apbpos->search(apbposnr => $apbpos_act,
                                               apbblattnr => $blatt,
                                               hpos => $hpos_id);
    
    my $apbzng_id = $self->{zdata}{apbposs}{$apbpos_act}{apbzng_id};
    $apbposrec->apbzng($apbzng_id);
    $apbposrec->update();
}

sub set_eintrag_teilzeichnung_erstellt{
    my ($self) = @_;
    
    my $teilzng = $self->{teilzngs}[0];
    
    my ($teilzngrec) = $self->{cdbh}->zz_teilzng->search(file => $teilzng);
    $teilzngrec->apb_erstellt('*');
    $teilzngrec->update();
}

sub daten_fuer_ftpliste{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    my $dbh = $cdbh->dbh();
    
    my $konst = $self->{konstrukteur};
    my $dat   = $self->{datum};
    
    my $sth = $dbh->prepare(qq( SELECT  file
                                FROM    zz_teilzng
                                WHERE   konst LIKE ?
                                AND     date LIKE ?
                                ORDER BY file));
    $sth->execute($konst, $dat);
    my @b3dposs;
    while (my $rec = $sth->fetchrow_arrayref()){
        push @b3dposs, $rec->[0]
    }
    
    my @ftpliste;
    for my $b3dpos (@b3dposs){
        my ($ts, $pos, $bl, $rev) = $b3dpos =~ m/hp(\d{6})0(\d{5})_(\d{2})_(\d{2})/;
        
        my $sth = $dbh->prepare(qq( SELECT  apbnr, revnr, tsnr, tsbez, apbposnr
                                    FROM    zz_v_ftp_liste
                                    WHERE   tsnr = ?
                                    AND     zngnr = ?
                                    AND     blattnr = ?
                                    AND     revnr LIKE ?));
        $sth->execute($ts, $pos, $bl, $rev);
        
        while (my @rec = $sth->fetchrow_array()){
            my $apbnr = $rec[0];
            $apbnr =~ s/\.//; #Punkt weg
            $apbnr =~ s!/!_!; #slash zu Unterstrich
            $apbnr =~ s/ //; #Leerstelle weg
            $apbnr =~ s/-/_/; #Minus zu Unterstrich
            
            my $rev = $rec[1];
            
            my $pdf_fn = $apbnr.'_'.$rev.'.pdf';
            my $dwg_fn = $apbnr.'_'.$rev.'.dwg';
            
            my $sonstigedateien = q();
            
            my $tsbez = $rec[3];
            my $apbposnr = $rec[4];
            
            my $plantitel = $tsbez.'  Pos '.$apbposnr;
            
            my $bauteilnr = $apbposnr;
            
            my $aenderungsbeschreibung = q();
            
            my $tsnr = $rec[2];
            my ($cube) = $tsnr =~ m/\d{3}(\d{3})/;
            
            my $cubennr = 'Cube '.$cube;
            
            push @ftpliste, [$pdf_fn, $dwg_fn, $sonstigedateien,
                             $plantitel, $bauteilnr, $aenderungsbeschreibung,
                             $cubennr];
        }
    }
    $self->{ftpliste} = \@ftpliste;
    return
}

sub pfad_fuer_ftp_liste{
    my ($self) = @_;
    
    my $cdbh = $self->{cdbh};
    my $dbh = $cdbh->dbh();
    
    my $konst = $self->{konstrukteur};
    my $dat   = $self->{datum};
    
    my $sth = $dbh->prepare(qq( SELECT  vol, dirs
                                FROM    zz_teilzng
                                WHERE   konst LIKE ?
                                AND     date LIKE ?
                                GROUP BY dirs));
    $sth->execute($konst, $dat);
    $self->{ftplistepfad} = $sth->fetchrow_arrayref();
}

sub _search_apb_index_alias{
    my ($self) = @_;
    
    my @alias;
    $alias[0] = "-A";
    
    return \@alias;
}

sub _search_apb_index_datum{
    my ($self) = @_;
    
    my @datum;
    $datum[0] = $self->{zdata}{datum};
        
    return \@datum;
}

sub _search_apb_index_gezeichnet{
    my ($self) = @_;
    
    my @zeichner;
    $zeichner[0] = $self->{zdata}{konst};
    
    return \@zeichner;
}

sub _search_apb_index_geprueft{
    my ($self) = @_;
    
    my @geprueft;
    $geprueft[0] = "KFE";
    
    return \@geprueft
}

sub _search_apb_index_genehmigt{
    my ($self) = @_;
    
    my @genehmigt;
    $genehmigt[0] = "FRI";
    
    return \@genehmigt
}

sub _search_apb_index_text{
    my ($self) = @_;
    
    my @text;
    $text[0] = $self->{zdata}{indextext};
    
    return \@text
}

sub _search_apb_zeichnungstitel{
    my ($self) = @_;
    
    my %zdata = %{$self->{zdata}};
    my $zngtyp = $zdata{zngtyp};
    my $blattanz = $zdata{blattanz};
    my $blatteintrag;
    if ($blattanz > 1){
        $blatteintrag = 'Blatt '.$zdata{blatt}.' von '.$zdata{blattanz} 
    }
    
    my $titlestr;
    if ($zngtyp eq 'hp'){
        my $unit = $zdata{unit};
        my $tsbez = $zdata{tsbez};
        my $apbpos_act = $self->{apbpos_act};
        my $cube = $zdata{cube};
        
        if ($blatteintrag){
            $titlestr = "UNIT $unit#Kesselhaus Stahlbau#$tsbez #Pos $apbpos_act $blatteintrag  CUBE $cube"
            }
        else{
            $titlestr = "UNIT $unit#Kesselhaus Stahlbau#$tsbez #Pos $apbpos_act  CUBE $cube"
        }
    }
    
    my @title = reverse (split '#', $titlestr);

    return \@title;
}

sub _search_apb_zeichnungnr{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{apbnr};

    return $znr;
}

sub _search_apb_index_aktuell{
    my ($self) = @_;
    
    return $self->{zdata}{revnr};
}

sub _search_apb_index_aktuell_datum{
    my ($self) = @_;
    
    my $val = $self->{zdata}{datum};;
    return $val;
}

sub _search_apb_gezeichnet_datum{
    my ($self) = @_;
    
    my $val = $self->{zdata}{datum};;
    return $val;
}

sub _search_apb_gezeichnet_name{
    my ($self) = @_;
    
    my $val = $self->{zdata}{konst};
    return $val;
}

sub _search_apb_geprueft_datum{
    my ($self) = @_;
    
    my $val = $self->{zdata}{datum};;
    return $val;
}

sub _search_apb_geprueft_name{
    my ($self) = @_;
    
    my $val = 'KFE';
    return $val;
}

sub _search_apb_genehmigt_datum{
    my ($self) = @_;
    
    my $val = $self->{zdata}{datum};;
    return $val;
}

sub _search_apb_genehmigt_name{
    my ($self) = @_;
    
    my $val = 'FRI';
    return $val;
}

sub _search_apb_dwgnr_extern1{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    
    my ($znr1, $znr2) = $znr =~ m/(\d{4}APB\S+)-(\w{3}\d{4}\d{4})/;
    
    my $ind = '-'.$self->{zdata}{revalias};    
    
    $znr = $znr1.'-   '.$znr2.' '.$ind;
    return $znr;
}

sub _search_apb_massstab1{
    my ($self) = @_;
    
    my $val = '1/10';
    return $val;
}

sub _search_apb_massstab2{
    my ($self) = @_;
    
    my $val = '1/15';
    return $val;
}

sub _search_apb_format{
    my ($self) = @_;
    
    my $val = 'A0';
    return $val;
}

sub _search_apb_kks_function{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    
    my ($kks) = $znr =~ m/\d{4}APB(\S+)-\w{3}\d{4}\d{4}/;

    return $kks;
}

sub _search_apb_dcc{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    
    my ($dcc) = $znr =~ m/\d{4}APB\S+-(\w{3})\d{4}\d{4}/;

    return $dcc;
}

sub _search_apb_dccno{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    
    my ($dccno) = $znr =~ m/\d{4}APB\S+-\w{3}(\d{4})\d{4}/;

    return $dccno;
}

sub _search_apb_dccpage{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    
    my ($dccpage) = $znr =~ m/\d{4}APB\S+-\w{3}\d{4}(\d{4})/;

    return $dccpage;
}

sub _search_apb_dccindex{
    my ($self) = @_;
    
    my $ind = '-'.$self->{zdata}{revalias};
    
    return $ind;
}

sub _search_apb_dateiname{
    my ($self) = @_;
    
    my $apbpos_act = $self->{apbpos_act};
    
    my $znr = $self->{zdata}{apbposs}{$apbpos_act}{rwenr};
    chomp $znr;
    my $ind = '-'.$self->{zdata}{revalias};    
    
    my $fileno = $znr.$ind;
    return $fileno;
}

sub _search_grundbeschichtung_my{
    my ($self) = @_;
    
    return $self->{zdata}{gbmy};
}

sub _search_grundbeschichtung_ral{
    my ($self) = @_;
    
    return $self->{zdata}{gbral};
}

sub _search_zwischenbeschichtung_my{
    my ($self) = @_;
    
    return $self->{zdata}{zbmy};
}

sub _search_zwischenbeschichtung_ral{
    my ($self) = @_;
    
    return $self->{zdata}{zbral};
}

sub _search_deckbeschichtung_my{
    my ($self) = @_;
    
    return $self->{zdata}{dbmy};
}

sub _search_deckbeschichtung_ral{
    my ($self) = @_;
    
    return $self->{zdata}{dbral};
}

sub _search_apb_skizzenbez{
    my ($self) = @_;
    
    my $unit = $self->{zdata}{unit};
    my $skbez = 'Eemshaven Block '.$unit;
    
    return $skbez;
}

sub _search_apb_planphase{
    my ($self) = @_;
       
    return 'A';
}

sub _search_wz_besteller{
    my ($self) = @_;
       
    return 'Alstom Power Systems GmbH';
}

sub _search_wz_bauwerk{
    my ($self) = @_;
       
    my $bauwerkstr = "RWE Power#Power Plant Eemshaven";
    my @bauwerk = grep {$_} reverse (split '#', $bauwerkstr);
    
    return \@bauwerk;
}

sub _search_wz_auftragnr{
    my ($self) = @_;
       
    return '090408';
}

sub _search_wz_zeichnungstitel{
    my ($self) = @_;
    
    my $titlestr = "Fertigung Teil 1#TS ?????";
    my @title = grep {$_} reverse (split '#', $titlestr);
    
    return \@title;
}

sub _search_wz_index{
    my ($self) = @_;
    
    my @index;
    $index[0] = "00";
    $index[1] = "01";
    $index[2] = "02";
    $index[3] = "03";
    $index[4] = "04";
    $index[5] = "05";
    $index[6] = "06";
    $index[7] = "07";
    $index[8] = "08";
    $index[9] = "09";
   
    return \@index;
}

sub _search_wz_index_text{
    my ($self) = @_;
    
    my @indextext;
    $indextext[0] = "texttexttext";
    $indextext[1] = "texttexttexttexttexttext";
    $indextext[2] = "texttexttexttexttexttexttexttexttext";
    $indextext[3] = "texttexttext";
    $indextext[4] = "texttexttexttexttexttexttexttexttexttexttexttext";
    $indextext[5] = "text";
    $indextext[6] = "texttexttext";
    $indextext[7] = "07texttexttext";
    $indextext[8] = "08texttexttext";
    $indextext[9] = "09texttexttext";
   
    return \@indextext;
}

sub _search_wz_index_datum{
    my ($self) = @_;
    
    my @indexdat;
    $indexdat[0] = "20.05.2010";
    $indexdat[1] = "21.05.2010";
    $indexdat[2] = "22.05.2010";
    $indexdat[3] = "23.05.2010";
    $indexdat[4] = "24.05.2010";
    $indexdat[5] = "25.05.2010";
    $indexdat[6] = "26.05.2010";
    $indexdat[7] = "27.05.2010";
    $indexdat[8] = "28.05.2010";
    $indexdat[9] = "29.05.2010";
   
    return \@indexdat;
}

sub _search_wz_index_gezeichnet{
    my ($self) = @_;
    
    my @indexgezeichnet;
    $indexgezeichnet[0] = "mho";
    $indexgezeichnet[1] = "mho";
    $indexgezeichnet[2] = "mho";
    $indexgezeichnet[3] = "mho";
    $indexgezeichnet[4] = "mho";
    $indexgezeichnet[5] = "mho";
    $indexgezeichnet[6] = "mho";
    $indexgezeichnet[7] = "mho";
    $indexgezeichnet[8] = "mho";
    $indexgezeichnet[9] = "mho";
   
    return \@indexgezeichnet;
}

sub _search_wz_index_projektleiter{
    my ($self) = @_;
    
    my @indexprojektleiter;
    $indexprojektleiter[0] = "KFE";
    $indexprojektleiter[1] = "KFE";
    $indexprojektleiter[2] = "KFE";
    $indexprojektleiter[3] = "KFE";
    $indexprojektleiter[4] = "KFE";
    $indexprojektleiter[5] = "KFE";
    $indexprojektleiter[6] = "KFE";
    $indexprojektleiter[7] = "KFE";
    $indexprojektleiter[8] = "KFE";
    $indexprojektleiter[9] = "KFE";
   
    return \@indexprojektleiter;
}

sub _search_wz_zeichnungnr{
    my ($self) = @_;
    
    return '00001'
}

sub _search_wz_blattnr{
    my ($self) = @_;
    
    return '08'
}

sub _search_wz_index_aktuell{
    my ($self) = @_;
    
    return '00'
}

sub _search_wz_massstab{
    my ($self) = @_;
    
    return '1/10/15'
}

sub _search_wz_format{
    my ($self) = @_;
    
    return 'A0'
}

sub _search_wz_gezeichnet_name{
    my ($self) = @_;
    
    return 'mho'
}

sub _search_wz_gezeichnet_tel{
    my ($self) = @_;
    
    return '-66'
}

sub _search_wz_gezeichnet_fax{
    my ($self) = @_;
    
    return '1066'
}

sub _search_wz_gezeichnet_email{
    my ($self) = @_;
    
    return 'hofmann@wendeler.de'
}

sub _search_wz_gezeichnet_datum{
    my ($self) = @_;
    
    return '20.10.2010'
}


sub _textblock_erstellen{
    my ($self, $hdtxtref, $txtstyle_id, $rows, $hgt, $argsref) = @_;
    
    my @args = @$argsref;
    my $anz = $#args + 1;
    my %hdtxt = %$hdtxtref;
    if($anz <= $rows){
        for my $i (1..$anz){
            my %hdtxttmp = %hdtxt;
            $hdtxttmp{val} = $args[$i - 1];
            $hdtxttmp{d0y} += ($i * $hgt / 10 / $rows) - $hgt / 10 / $rows;
            %hdtxttmp = %{$self->_hdtxt2textstyle(\%hdtxttmp, $txtstyle_id)};
            $self->{hdtxtvars}{$hdtxt{var}.'part'.$i} = \%hdtxttmp
        }
    }
    elsif($anz > $rows){
        my $rest = $anz - $rows - 1;
        for (my $i = $anz; $i > $rest; $i--){
        my %hdtxttmp = %hdtxt;
            $hdtxttmp{val} = $args[$i];
            $hdtxttmp{d0y} += (($i - $rest) * $hgt / 10 / $rows) - $hgt / 10 / $rows;
            %hdtxttmp = %{$self->_hdtxt2textstyle(\%hdtxttmp, $txtstyle_id)};
            $self->{hdtxtvars}{$hdtxt{var}.'part'.$i} = \%hdtxttmp;
        }
    }
    return;
}

sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}    
1;
