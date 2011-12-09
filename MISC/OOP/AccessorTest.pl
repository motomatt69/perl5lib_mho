#!/usr/bin/perl -w
use strict;
package Altoids;

use base qw(Class::Accessor);
use fields qw(curiously strong mints);
Altoids->mk_accessors();#Altoids->show_fields('Public'));

sub new {
    my $proto = shift;
    my $class = ref ($proto || $proto);
                     return fields::new($class);
}

my Altoids $tin = Altoids->new;
$tin->curiously('Curiouser and curiouser');
print $tin->{curiously};