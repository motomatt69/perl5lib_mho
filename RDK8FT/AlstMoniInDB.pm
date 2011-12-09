package RDK8FT::AlstMoniInDB;
use strict;
use RDK8FT::File::Paths;
use File::Spec;
use Zeitmessung::Zeitmessung;
use RDK8FT::MON_DB::MON;
use Patterns::Observer qw(:subject);

use Win32::OLE qw(in with);
use Win32::OLE::Const 'Microsoft Excel';
use Win32::OLE::Variant;
use Win32::OLE::NLS qw(:LOCALE :DATE);
$Win32::OLE::Warn = 3; #3 bedeutet Die on errors

sub new{
    my ($class) = @_;
    
    return bless {}, $class;
}

sub printtrace{
    my ($self, $data) = @_;
    
    $self->{prndat} = $data;
    $self->notify('printtrace');
}

sub get_prndat{
    my ($self) = @_;
    
    return $self->{prndat};
}

sub set_alstom2db{
    my ($self, $in_file) = @_;
    
    my $data_ref = $self->exc_daten_holen($in_file);
    my @datas = @$data_ref;
    
    my $dbh = RDK8FT::MON_DB::MON->new();
    
    foreach my $data (@datas) {
        #print ($data->[0]);
        $self->printtrace($data->[0],"\n");
        if ($data->[0] =~ m/^8\d{7}$/) {
            my ($rec_vorh) = $dbh->monitor_1->search({position => $data->[0]});
            if ($rec_vorh) {
                print " update\n";
                $self->printtrace(" update\n");
                #$rec_vorh->cube_be($data->[1]);
                #$rec_vorh->cube_de($data->[2]);
                #$rec_vorh->mont_rel($data->[3]);
                #$rec_vorh->erection($data->[4]);
                #my $znr = $data->[5];
                #if ($znr =~ m/(^21)( )(\d{3}-\d{4})/){
                #    my ($g1, $g2, $g3) = $znr =~ m/(^21)( |)(\d{3}-\d{4})/;
                #    $znr = $g1.$g3;
                #}
                #$rec_vorh->workshopdwg_de($znr);
                #$rec_vorh->actual_rev($data->[6]);
                #$rec_vorh->fabricator($data->[7]);
                #$rec_vorh->workshopdwg_fab($data->[8]);
                #$rec_vorh->manufactured_rev($data->[9]);
                #$rec_vorh->ft_del($data->[10]);
                #$rec_vorh->ft_mod($data->[11]);
                #$rec_vorh->difference_rev($data->[12]);
                #$rec_vorh->info_bf($data->[13]);
                #$rec_vorh->deli_loc($data->[14]);
                #$rec_vorh->date_of_deli($data->[15]);
                #$rec_vorh->fabricated_rev_bf($data->[16]);
                #$rec_vorh->difference_rev_bf($data->[17]);
                #$rec_vorh->refodisp($data->[18]);
                #$rec_vorh->new_bundle($data->[19]);
                #$rec_vorh->date_of_outgoing_bf($data->[20]);
                #$rec_vorh->info_from_bf($data->[21]);
                #$rec_vorh->deli_date_baust($data->[22]);
                #$rec_vorh->weight_de($data->[23]);
                #$rec_vorh->weight_prog($data->[24]);
                #$rec_vorh->shipment1($data->[25]);
                #$rec_vorh->bundle($data->[26]);
                
                $rec_vorh->cube($data->[1]);
                $rec_vorh->erection_seq($data->[2]);
                $rec_vorh->workshopdwg_de($data->[3]);
                $rec_vorh->actual_rev($data->[4]);
                $rec_vorh->fabricator($data->[5]);
                $rec_vorh->workshopdwg_fab($data->[6]);
                $rec_vorh->manufactured_rev($data->[7]);
                $rec_vorh->diff_rev_act_man ($data->[8]);
                $rec_vorh->parts_state_prog($data->[9]);
                $rec_vorh->info_bf($data->[10]);
                $rec_vorh->deli_loc($data->[11]);
                $rec_vorh->shipment($data->[12]);
                $rec_vorh->bundle($data->[13]);
                $rec_vorh->weight_de($data->[14]);
                $rec_vorh->weight_prog($data->[15]);
                $rec_vorh->diff_rev_act_bffab($data->[16]);
                $rec_vorh->auschecken_wen($data->[17]);
                $rec_vorh->checkout_conv_bf($data->[18]);
                $rec_vorh->info_from_bf_wen($data->[19]);
                $rec_vorh->deli_date_wen($data->[20]);
                $rec_vorh->req_ready_for_disp($data->[21]);
                $rec_vorh->conf_ready_for_disp($data->[22]);
                $rec_vorh->ready_for_disp($data->[23]);
                $rec_vorh->new_bun_wen($data->[24]);
                $rec_vorh->date_of_outgoing_bf($data->[25]);
                $rec_vorh->fab_rev_bf($data->[26]);
                $rec_vorh->in_excel($data->[27]);
                
                $rec_vorh->update();
            }
            else{
                #print " neu\n";
                $self->printtrace(" neu\n");
                my $znr = $data->[3];
                #if ($znr =~ m/(^21)( )(\d{3}-\d{4})/){
                #    my ($g1, $g2, $g3) = $znr =~ m/(^21)( |)(\d{3}-\d{4})/;
                #    $znr = $g1.$g3;
                #}
                my $rec = $dbh->monitor_1->find_or_create({                                                         
                                                         position => $data->[0],
                                                         cube => $data->[1],
                                                         erection_seq => $data->[2],
                                                         workshopdwg_de => $data->[3],
                                                         actual_rev => $data->[4],
                                                         fabricator => $data->[5],
                                                         workshopdwg_fab => $data->[6],
                                                         manufactured_rev => $data->[7],
                                                         diff_rev_act_man  => $data->[8],
                                                         parts_state_prog => $data->[9],
                                                         info_bf => $data->[10],
                                                         deli_loc => $data->[11],
                                                         shipment => $data->[12],
                                                         bundle => $data->[13],
                                                         weight_de => $data->[14],
                                                         weight_prog => $data->[15],
                                                         diff_rev_act_bffab => $data->[16],
                                                         auschecken_wen => $data->[17],
                                                         checkout_conv_bf => $data->[18],
                                                         info_from_bf_wen => $data->[19],
                                                         deli_date_wen => $data->[20],
                                                         req_ready_for_disp => $data->[21],
                                                         conf_ready_for_disp => $data->[22],
                                                         ready_for_disp => $data->[23],
                                                         new_bun_wen => $data->[24],
                                                         date_of_outgoing_bf => $data->[25],
                                                         fab_rev_bf => $data->[26],
                                                         in_excel => $data->[27],
                                                         });
            }
            
        }
    }
}
        
sub exc_daten_holen{
    my ($self, $in_file) = @_;
    
    my $dir = RDK8FT::File::Paths->get_monitoring_dir();
    
    my $in_path = File::Spec->catfile($dir, $in_file);
    
    my $excel = Win32::OLE->GetActiveObject('Excel.Application')
                    || Win32::OLE->new('Excel.Application','Quit');
    $excel->{DisplayAlerts}=0;
    $excel->{Visible} = 0;
    
    my $book = $excel->Workbooks->open($in_path);
    my $sheet= $book->Worksheets(1);
    $sheet->{AutoFilterMode} = 0;
    
    my $maxr = $sheet->UsedRange->Rows->Count;
    $self->printtrace("maxr aus used range:  $maxr\n");
    
    while (!$sheet->Range("B$maxr")->{'Value'}) {
        $maxr --;
    }
    $self->printtrace("maxr korrigiert:  $maxr\n");        
    
    
    my $range = $sheet->Range("A2:Z$maxr")->{'Value'};
    
    $sheet->Range("A1")->Select;
    $book->Save;
  
    $book->Close;
    $excel-> Quit;
    
    return $range;
}
1;