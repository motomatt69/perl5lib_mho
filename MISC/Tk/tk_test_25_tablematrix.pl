#!/usr/bin/perl -w
use strict;

use Tk;
use Tk::TableMatrix;
require Tk::JBrowseEntry;
require Tk::DragDrop;
require Tk::DropSite;
use strict;

my $tm_array = {};
my $t;
my @drag = ();
my @drop = ();
my @pos = (0, 0);
my @old_pos = (0, 0);

sub switch_cells
 {
  if ($drag[0] == $drop[0]) # Selbe Zeile
   {
    if ($drag[1] >= 0) # Kein Titel
     { 
      my $drag_coords = $drag[0].','.$drag[1];
      my $drop_coords = $drop[0].','.$drop[1];
      my $drag_val = $tm_array->{$drag_coords};
      my $drop_val = $tm_array->{$drop_coords};

      $t->set($drop_coords, $drag_val);
      $tm_array->{$drop_coords} = $drag_val;

      $t->set($drag_coords, $drop_val);
      $tm_array->{$drag_coords} = $drop_val;
     }
   }
 }

my $start_row = -3;
my $end_row = 50;
my $start_col = -1;
my $end_col = 50;
my $display_cols = 10;
my $display_rows = 10; 
my $nr_rows = $end_row - $start_row + 1;
my $nr_cols = $end_col - $start_col + 1;
my $title_rows = ($start_row < 0) ? (abs($start_row)) : (0);
my $title_cols = ($start_col < 0) ? (abs($start_col)) : (0);

foreach my $row  (($start_row - $title_rows)..4)
 {
  foreach my $col (($start_col - $title_cols)..$end_col)
   {
    $tm_array->{"$row,$col"} = "$row:$col";
   }
 }

my $top = MainWindow->new;
$top->geometry('870x300');

$top->bind( '<MouseWheel>', [ sub { $_[0]->yviewScroll(-($_[1]/120)*3, 'units'); }, Tk::Ev('D') ] );

$t = $top->Scrolled( 'TableMatrix', 
                     -titlerows => $title_rows,   -titlecols => $title_cols,
                     -rows =>      $nr_rows,      -cols =>      $nr_cols, 
                     -height =>    $display_rows, -width =>     $display_cols, 
                     -variable => $tm_array,
                     -roworigin => $start_row,
                     -colorigin => $start_col, 
                     -colstretchmode => 'none',
                     -rowstretchmode => 'none',
                     -selectmode => 'single',
                     -drawmode => 'fast',
                     -maxwidth => 800,
                     -maxheight => 600,
                     -rowheight => -20,
                     -colwidth => -200,
                     -resizeborders => 'none',
                     -sparsearray => 0, 
                     -selecttitle => 0,                     
                     -state => 'disabled',
                     -font => ['Tahoma', 10, 'bold'],
                     -bg => '#D4D0C8',
                     -fg => '#000000' 
);

$t->tagConfigure('Normal',       -bg => '#D4D0C8', -fg => 'black');
$t->tagConfigure('DragSelected', -bg => '#EEEE11', -fg => 'black');
#$t->tagConfigure('DarkRed',      -bg => '#881111', -fg => 'black');
#$t->tagConfigure('LightRed',     -bg => '#EE9999', -fg => 'black');
#$t->tagConfigure('DarkGreen',    -bg => '#118888', -fg => 'black');
#$t->tagConfigure('LightGreen',   -bg => '#99EEEE', -fg => 'black');


my $cb_use = $t->Checkbutton( -text => 'nutzen' ); 
my @test_arr = ( 'TEXT', 'ZAHL', '#.## ¤', '#.## ¤ / # ¤', 'PLZ', 'TT.MM.JJJJ', 'TT.MM.JJ' );
my $test_var = $test_arr[0];
my $be_format = $t->JBrowseEntry( -label => '', -variable => \$test_var, -choices => \@test_arr,
                                  -state => 'normal', -font => ['Tahoma', 8], -width => 10 );
my $lbl_hl = $top->Label(-text => "Headline");

$t->windowConfigure("-3,0", -window=>$cb_use); 
$t->windowConfigure("-2,0", -window=>$be_format); 
$t->windowConfigure("-1,0", -window=>$lbl_hl); 

my $dragging = 0;
my $dragscroll_handler;
my $dragscroll_delay = 150;
my $dragspeed_delay = 50;
my $nr_repeated = 0;
my $speed_repeat = 10;
sub handle_dragscroll
 {
  if ($dragging == 0)
   {
    $dragscroll_handler->cancel;
   }
  my ($x_scrollbar_width, $y_scrollbar_height) = (21, 21);
  my ($mouse_x, $mouse_y) = $t->pointerxy;
  my ($x_left, $x_right) = ($t->rootx, $t->rootx + $t->width);
  my ($y_top, $y_bottom) = ($t->rooty, $t->rooty + $t->height);
  my $x_scroll = ($mouse_x < ($x_left + $x_scrollbar_width)) ? (-1) : (($mouse_x < $x_right) ? (0) : (1));
  my $y_scroll = ($mouse_y < $y_top) ? (-1) : (($mouse_y < ($y_bottom - $y_scrollbar_height)) ? (0) : (1));
  if (($x_scroll) == 0 and ($y_scroll == 0))
   {
    $dragscroll_handler->time($dragscroll_delay) unless ($nr_repeated == 0);
    $nr_repeated = 0;
   } 
  else
   {
    $nr_repeated++;
    $dragscroll_handler->time($dragspeed_delay) if ($nr_repeated >= $speed_repeat);
   }
  $t->xviewScroll($x_scroll, 'units'); 
  $t->yviewScroll($y_scroll, 'units');
 }


my ($dnd_t, $ds_t);

$dnd_t = $t->DragDrop( -event => '<B1-Motion>', 
                       -sitetypes => [qw(Local)], 
                       -startcommand =>  sub {
                                              my @coords = split(",", $t->index('@'.($t->pointerx - $t->rootx).','.($t->pointery - $t->rooty))); 
                                              if (($coords[0] >= 0) and ($coords[1] >= 0))
                                               {
                                                $dragging = 1;
                                                $dragscroll_handler = $top->repeat($dragscroll_delay, \&handle_dragscroll);
                                                $t->tagCell('Normal', $drop[0].','.$drop[1]) if (@drop); 
                                                $t->tagCell('Normal', $drag[0].','.$drag[1]) if (@drag); 
                                                @drag = @coords;
                                                @old_pos = @pos;  
                                                @pos = @drag;
                                                $dnd_t->configure( -text => $tm_array->{$drag[0].','.$drag[1]} );
                                                $t->tagCell('DragSelected', $drag[0].','.$drag[1]); 
                                                return 0;
                                               }
                                              else
                                               { return(1); }
                                             } );
$dnd_t->bind('<ButtonRelease>', sub { $dragging = 0; } );
$ds_t = $t->DropSite ( -droptypes     => ['Local'], 
                       -dropcommand   => sub { 
                                              $dragging = 0;
                                              $dragscroll_handler->cancel;
                                              @drop = split(",", $t->index('@'.($t->pointerx - $t->rootx).','.($t->pointery - $t->rooty))); 
                                              @old_pos = @pos;  
                                              @pos = @drop;
                                              $t->tagCell('Normal', $drag[0].','.$drag[1]); 
                                              $t->tagCell('DragSelected', $drop[0].','.$drop[1]);                
                                              &switch_cells; 
                                             } );

my $button = $top->Button( -text => 'Exit', -width => 135, -command => sub{ $top->destroy } ); 
$t->place( -x =>  20, -y => 20 );

$button->place( -x => 20, -y => 260 );

$t->tagCell('DragSelected', $pos[0].','.$pos[1]);   

sub change_position
 {  
  my ($y, $x) = @_;
  my @new_pos = ($pos[0] + $y, $pos[1] + $x);
  return if (($new_pos[0] < 0) or ($new_pos[0] > $end_row) or ($new_pos[1] < 0) or ($new_pos[1] > $end_col));
  $t->tagCell('Normal', $pos[0].','.$pos[1]); 
  $t->tagCell('DragSelected', $new_pos[0].','.$new_pos[1]);    
  @old_pos = @pos;  
  @pos = @new_pos;
  $t->see(join(",", @pos));
 }

$top->bind( '<KeyPress-Left>',  sub { &change_position(  0, -1 ); } );
$top->bind( '<KeyPress-Right>', sub { &change_position(  0,  1 ); } );
$top->bind( '<KeyPress-Up>',    sub { &change_position( -1,  0 ); } );
$top->bind( '<KeyPress-Down>',  sub { &change_position(  1,  0 ); } );

Tk::MainLoop;

