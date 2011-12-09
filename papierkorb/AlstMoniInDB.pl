#!/usr/bin/perl -w
use strict;
use RDK8FT::File::Paths;
use File::Spec;
use Spreadsheet::ParseExcel;
use Spreadsheet::DataFromExcel;
use Zeitmessung::Zeitmessung;
use RDK8FT::MON_DB::MON;
use RDK8FT::stl_stand2db

my $dbh = RDK8FT::MON_DB::MON->new();


my $Zeit1 = Zeitmessung->new();

my $dir = RDK8FT::File::Paths->get_monitoring_dir();

my $in_file = 'Monitoring WEN KW 49.xls';
my $in_path = File::Spec->catfile($dir, $in_file);

my $parser = Spreadsheet::DataFromExcel->new();
my $data_alstom_ref = $parser->load($in_path,
                         undef,
                         4,
                         2000,
                         )or die $parser->error;

my @data_alstom = @$data_alstom_ref;

foreach my $data (@data_alstom) {
    print $data->[0];
    if ($data->[0] =~ m/^8\d{7}$/) {
        my ($rec_vorh) = $dbh->monitor->search({position => $data->[0]});
        if ($rec_vorh) {
            print " update\n";
            $rec_vorh->cube($data->[1]);
            $rec_vorh->mont_rel($data->[2]);
            $rec_vorh->erection($data->[3]);
            $rec_vorh->workshopdwg_de($data->[4]);
            $rec_vorh->actual_rev($data->[5]);
            $rec_vorh->fabricator($data->[6]);
            $rec_vorh->workshopdwg_fab($data->[7]);
            $rec_vorh->manufactured_rev($data->[8]);
            $rec_vorh->ft_del($data->[9]);
            $rec_vorh->ft_mod($data->[10]);
            $rec_vorh->difference_rev($data->[11]);
            $rec_vorh->info_bf($data->[12]);
            $rec_vorh->deli_loc($data->[13]);
            $rec_vorh->date_of_deli($data->[14]);
            $rec_vorh->fabricated_rev_bf($data->[15]);
            $rec_vorh->difference_rev_bf($data->[16]);
            $rec_vorh->refodisp($data->[17]);
            $rec_vorh->new_bundle($data->[18]);
            $rec_vorh->date_of_outgoing_bf($data->[19]);
            $rec_vorh->info_from_bf($data->[20]);
            $rec_vorh->weight_de($data->[21]);
            $rec_vorh->weight_prog($data->[22]);
            $rec_vorh->shipment1($data->[23]);
            $rec_vorh->bundle($data->[24]);
            $rec_vorh->deli_date_baust($data->[25]);
            $rec_vorh->update();
        }
        else{
            print " neu\n";
            my $rec = $dbh->monitor->find_or_create({position => $data->[0],
                                                     cube => $data->[1],
                                                     mont_rel => $data->[2],
                                                     erection => $data->[3],
                                                     workshopdwg_de => $data->[4],
                                                     actual_rev => $data->[5],
                                                     fabricator => $data->[6],
                                                     workshopdwg_fab => $data->[7],
                                                     manufactured_rev  => $data->[8],
                                                     ft_del => $data->[9],
                                                     ft_mod => $data->[10],
                                                     difference_rev => $data->[11],
                                                     info_bf => $data->[12],
                                                     deli_loc => $data->[13],
                                                     date_of_deli => $data->[14],
                                                     fabricated_rev_bf => $data->[15],
                                                     difference_rev_bf => $data->[16],
                                                     refodisp => $data->[17],
                                                     new_bundle => $data->[18],
                                                     date_of_outgoing_bf => $data->[19],
                                                     info_from_bf => $data->[20],
                                                     weight_de => $data->[21],
                                                     weight_prog => $data->[22],
                                                     shipment1 => $data->[23],
                                                     bundle => $data->[24],
                                                     deli_date_baust => $data->[25],
                                                     });
        }
        my ($gew, $beastand, $color) = RDK8FT::stl_stand2db->get_bearbeitungsstand($rec_vorh->position);
        $rec_vorh->beastand($beastand);
        $rec_vorh->gew($gew);
        $rec_vorh->color($color);
        $rec_vorh->update;
    }
}

$Zeit1->set_ende();

print "Zeit: ".$Zeit1->get_dauer();
1;