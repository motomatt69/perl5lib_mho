package tree;
use strict;

sub new {
    my ($type)= $_[0];
    my ($self) = {};
    $self->{'root'} = $_[1];
    $self->{'dirfcn'} = $_[2];
    $self->{'filefcn'} = $_[3];
    bless ($self, $type);
    return $self;
}
    
sub tellroot {
    my ($self) = $_[0];
    print "Root is: ", $self->{'root'},"\n";
}

sub cruisetree {
    my($self)=$_[0];
    $self->onedir($self->{'root'});
}

sub onedir {
    my $self=$_[0];
    my ($dirname) = $_[1];
    
    opendir (DIR, $dirname);
    my (@names) = readdir(DIR);
    closedir (DIR);
    
    if ($dirname =~ /(.*)\\$/) {
        $dirname = $1;
    }
    
    my ($Name);
    foreach $Name (@names) {
        chomp($Name);
        my ($Path) = "$dirname\\$Name";
            if ( -d $Path) {
                if (($Name ne "..") && ($Name ne ".")) {
                    &{$self->{'dirfcn'}} ($Path, $Name);
                    $self->onedir($Path)
                }
            }else{
                &{$self->{'filefcn'}} ($Path, $Name)
            }
    }
    return;
}
1;