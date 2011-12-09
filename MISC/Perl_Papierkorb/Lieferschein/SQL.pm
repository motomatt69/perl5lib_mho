package Lieferschein::SQL;
use strict;
use DBI;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(get_values);

my $dbh = DBI->connect('DBI:mysql:database=auftrag;host=server-sql','archiv','');
my $sth1 = $dbh->prepare(qq/
                        SELECT c.zng_group_bez as gruppe
                        FROM zng_data a, zng_lfnr b, zng_group c
                        WHERE a.zng_data_anr = '080335'
                        AND   a.zng_data_znr = ?
                        AND   a.zng_data_blatt = '01'
                        AND   a.zng_data_index = '00'
                        AND   b.zng_data_id = a.zng_data_id
                        AND   c.zng_group_id = b.zng_group_id
                        /);
my $sth2 = $dbh->prepare(qq/
                         SELECT zng_files_alias as enr
                         FROM zng_files
                         WHERE zng_files_anr = '080335'
                         AND   zng_files_znr = ?
                         AND   zng_files_blatt = '01'
                         AND   zng_files_index = '00'
                         AND   zng_files_typ like 'BMF_EXTREM'
                         /);


sub get_values {
    my ($tsnr) = @_;
    
    $sth1->execute($tsnr);
    my ($gr) = $sth1->fetchrow_array();
    $sth1->finish;
    $sth2->execute($tsnr);
    my ($ez) = $sth2->fetchrow_array();
    $sth2->finish;
    $ez =~ s/(\.bmf_$|\.BMF_$)//;
    
    return ($gr, uc($ez));
}


1;