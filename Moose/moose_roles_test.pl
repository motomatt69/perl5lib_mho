#!/usr/bin/perl -w
use strict;
use Moose::cat;
use Moose::cheese;

my %beides;
my %cats = ('Oma' => 'Maunzi',
            'Opa' => 'Tigerle',
            'Tochter' => 'Schnepfe',
            );

my $cnt = 0;
for my $key (sort keys %cats){
    my $name = $cats{$key};
    $cats{$key} = Moose::cat->new(name => $name,
                                  besitzer => $key,
                                  birth_year => (1990 + $cnt),
                                  );
    
    $beides{$key} = $cats{$key};
    
    print "Created a cat for ", $cats{$key}->besitzer(),"\n";
    print "Name: ", $cats{$key}->name(),"\n";
    print 'Age: ',$cats{$key}->age(),"\n";
    
    $cnt++;
}

my %kaese = ('Papa' => 'Gouda',
             'Sohn' => 'Pegorino',
             );

for my $key (sort keys %kaese){
    my $name = $kaese{$key};
    $kaese{$key} = Moose::cheese->new(name => $name,
                                  besitzer => $key);
    
    $beides{$key} = $kaese{$key};
    
    print "Created a Käs for ", $kaese{$key}->besitzer(),"\n";
    print "Name: ", $kaese{$key}->name(),"\n";
    print 'Age: ',$kaese{$key}->age(),"\n";
}

for my $key (sort keys %beides){
    if ($beides{$key}->DOES('Moose::living_being')){
        print $beides{$key}->name(), " is alive\n"
    }else{
        print $beides{$key}->name(), " is wohl tot\n"
    }
}


my $dummy;




