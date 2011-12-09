use strict;
use warnings;

package MyApp;

use Moose;
use MooseX::NonMoose;

use Wx qw/ :everything /;
extends 'Wx::App';

use WX::wx_myframe;


has foo => (is => 'rw', default => 12);
has args => (is => 'rw', isa => 'HashRef', default => sub{{}}, trigger => \&_set_args, lazy => 1);
has frame => (is => 'ro', isa => 'WX::wx_myframe', init_arg => undef, builder => '_build_frame', lazy => 1);

sub FOREIGNBUILDARGS{
    return
}

sub _build_frame{
    
    print "build frame\n";

    return WX::wx_myframe->new(title => 'superduper');
}

sub OnInit{
    my ($self) = @_;
    
    my $args = $self->args();
    print "OnInit\n";
    
    $self->frame();
    
    print "nach Framerstellung\n";
    $self->frame->Show;
    return 1;
}

sub _set_args{
    my @test = @_;
    
    my $dummy;
}
1;

package main;

use WX::wx_mysubframe1;


my $wx = MyApp->new(args => {title => 'Tolle App'});

print $wx->foo() ,"\n";#->MainLoop;
$wx->frame->SetTitle('Chef');

my $subframe1 = WX::wx_mysubframe1->new(wx => $wx);
$subframe1->init_subframe1();

$wx->MainLoop;
my $dummy;





