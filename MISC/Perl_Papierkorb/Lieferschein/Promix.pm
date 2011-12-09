package Lieferschein::Promix;
use strict;
use base 'Exporter';
our @EXPORT_OK = qw(getKopfHandle getLieferHandle);
use DBI;
sub connect {
    my $dbh = DBI->connect('dbi:ODBC:odbcprof8');
    return $dbh;
};

sub getKopfHandle {
    my ($dbh) = @_;
    my $sth = $dbh->prepare(qq/
                SELECT l.liek_dat, sum(b.bebu_gewicht)
                FROM p3_liek l, p3_bebu b
                WHERE l.liek_nr = ?
                AND   b.bebu_kopfnr = l.liek_nr
                AND   b.bebu_von = '521'
                AND   b.bebu_an  = '140'
                AND   b.bebu_storno = '-'
                GROUP BY l.liek_dat
                            /);
    return $sth;
}

sub getLieferHandle {
    my ($dbh) = @_;
    my $sth = $dbh->prepare(qq/
                SELECT z.zng_nr, a.aup_pos, sum(b.bebu_menge)
                FROM p3_liek l, p3_bebu b, aufpos a, zeichnung z
                WHERE l.liek_nr = ?
                AND   b.bebu_kopfnr = l.liek_nr
                AND   b.bebu_von = '521'
                AND   b.bebu_an  = '140'
                AND   b.bebu_storno = '-'
                AND   a.aup_id   = b.bebu_aupid
                AND   z.zng_id   = a.aup_zng_id
                GROUP BY z.zng_nr, a.aup_pos
                ORDER BY z.zng_nr, a.aup_pos
                  /);
    return $sth;
}


1;