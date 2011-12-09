package WX::wx_gridtest;
use base qw(Wx::App);
use Wx qw (:everything);
use Wx::Event qw(:everything);
use Wx::Grid;

sub insert_grid{
    my ($frame) = @_;
    
    my $grid = Wx::Grid->new( $frame,  -1,  [-1, -1], [640, 480],
                             );
    
    my ($rnr, $cnr) = (3000, 10);
    $grid->CreateGrid($rnr, $cnr);
    
    $grid->SetCellValue(1, 1, 100);
    $grid->SetReadOnly(1, 0);
    $grid->SetCellValue(1, 0, "This is read-only" );
    $grid->SetCellValue(2, 0, "coloured");
    $grid->SetCellTextColour(2, 0, Wx::Colour->new(255,0,0));
    
    map {$grid->SetCellBackgroundColour($_, 2, Wx::Colour->new(255,255,128))} (1..1000);
    $grid->SetColFormatFloat(0, 3, 2); #spalte 0, ?, 2 stellen hinterm komma 
    $grid->SetCellValue(3, 0, "3223.1415");
    
    $grid->SetRowSize( 1, 100 );
    $grid->SetColSize( 2, 200 );

    $grid->SetColLabelValue(0,"Column 0 Label Value");
    $grid->SetRowLabelSize(150);
    $grid->SetRowLabelValue(0,"Row 0 Label Value");

    
    #for my $r (0..$rnr){
    #    for my $c (1..$cnr){
    #        $grid->SetCellValue($r, $c, $r * 10000 + $c);
    #        my $v = $grid->GetCellValue($r, $c);
    #        print $v,"\n";            
    #    }
    #}
    
    
    
    Wx::Event::EVT_GRID_CELL_LEFT_CLICK($grid, \&get_cell_value);
}

sub get_cell_value{
    my ($grid, $event) = @_;
   
    for my $r (0..100){
        for my $c (1..100){
            $grid->SetCellValue($r, $c, $r * 10000 + $c);
            my $v = $grid->GetCellValue($r, $c);
            print $v,"\n";            
        }
    }
    
   # my $c = $grid->GetSelectedCells();
   # print $$c;
   # 
   #my ($colour) = $grid->GetCellBackgroundColour(2, 2);
   #print $colour,"\n";
   ## my @cells = $grid->GetSelectedCells([10, 10);
   #my $v = $grid->GetCellValue(10, 3);
   #print $$v, "\n";
   # 
   # my $cnr = $grid->GetNumberRows();
   # print $cnr,"\n";
   # my $cnc = $grid->GetNumberCols();
   # print $cnc,"\n";
   # 
   # my $dummy;
   # 
   
}




1;



