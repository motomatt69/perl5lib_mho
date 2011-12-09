use Date::Calc qw(:all);



my ($y, $m, $d) = Today([localtime]);
my $today = $y.'-'.(sprintf "%02d", $m).'-'.(sprintf "%02d", $d);

  use Date::Calc qw( Delta_Days Add_Delta_Days );

  @start = (2010,6,1);
  @stop  = ($y, $m, $d);

  $j = Delta_Days(@start, @stop);
  my %w2w;  
  for ( $i = 0; $i <= $j; $i += 7 ){
      @date = Add_Delta_Days(@start, $i);
      my ($week, $year) = Week_of_Year(@date);
      $w2w{$year.(sprintf "%02d", $week)} = 0;
  }

my $dummy;

#my %w2w;
#my $w = $startkw;
#while ($w < $actkw){
#    $w2w{$w} = 0;
#    $w++;
#    if ($w =~ m/53$/){
#        $w
#    }
#}




my $dummy;

sub _kalenderwoche{
	my (@date) = @_;
	
    #$date =~ s/_/-/g;
	my ($yyyy, $mm, $dd) = $date =~ m/(\d{4})-(\d{2})-(\d{2})/;
	my ($week, $year) = Week_of_Year(@date);
	
	return ($year.(sprintf "%02d", $week));
}