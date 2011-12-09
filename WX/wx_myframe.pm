package WX::wx_myframe;

use Moose;
use MooseX::NonMoose;

use Wx;
use Wx::Event qw/:everything/;
extends 'Wx::Frame';

has title => (is => 'rw', isa => 'Str', required => 0, default => 'Hello World', trigger => \&_change_title);
has panel => (is => 'rw');


sub FOREIGNBUILDARGS{
    my $class = shift;
    my %args = @_;
    
    print "FOREIGNBUILDARGS\n";
    
    my $title = (exists $args{title}) ? $args{title} : 'Hello World!';
    
    return (undef, -1, $title, [-1, -1], [-1, -1]);
}

sub BUILD{
    my $self = shift;
    
    print "BUILD\n";
    
    $self->panel(Wx::Panel->new($self));
    
    Wx::StaticText->new($self->panel, -1, 'Welcome to wxperl', [20, 20]);
    my $bto = Wx::Button->new($self->panel, -1, 'Click me', [20,40],);
    
    EVT_BUTTON($self, $bto, \&_title_random);
}

sub _change_title{
    my $self = shift;
    my $title = shift;
    
    print "Change Title\n";
    
    $self->SetTitle($title);
}

sub _title_random{
    my ($self, $e) = @_;
    
    my $bto = $e->GetEventObject;
    
    my $rand = sprintf '%03d', rand(1000);
    $self->title("title_$rand");
    return;
    my $dummy
}

no Moose;

1;
