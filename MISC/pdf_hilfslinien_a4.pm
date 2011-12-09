package Misc::pdf_hilfslinien_a4;
use strict;

sub new{
    my ($class, $pdf, $page) = @_;
    my $self = bless {}, $class;
    
    $self = {'pdf' => $pdf,
             page => $page,
            };
    draw($self);
    
    return $self;
}

sub draw{
    my ($self) = @_;
    
    my ($pdf, $page) = ($self->{pdf}, $self->{page});
                                
    my $font = $pdf->corefont('Helvetica-Bold');
    my $y;
    
    for  ($y = 0; $y <= 900; $y += 20) {
        my $line_vert = $page->gfx;
        $line_vert->move(0,$y);
        $line_vert->line(650,$y);
        $line_vert->strokecolor('blue');
        $line_vert->stroke;
        my $txt = $page->gfx;
        $txt->textlabel(40, $y, $font,8,$y,
                    -align => 'left',
                   );
    }
    
    my $x;
    for  ($x = 0; $x <= 600; $x += 20) {
        my $line_hori = $page->gfx;
        $line_hori->move($x,0);
        $line_hori->line($x,850);
        $line_hori->strokecolor('red');
        $line_hori->stroke;
        my $txt = $page->gfx;
        $txt->textlabel($x, 20, $font,8,$x,
                        -align => 'left',
                        -rotate => 90,
                       );
    }
}

1;