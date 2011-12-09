package Slots;
use strict;
use Scalar::Util qw(refaddr blessed);
use feature qw(say);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(SIGNAL SLOT PROVIDE CONNECT DISCONNECT EMIT);

INIT {
    my %provided  = ();
    my %connected = ();

    sub set_provided { my ($c_key, $func_ref) = @_; $provided{$c_key} = $func_ref; }
    sub get_provided { my ($c_key) = @_; return $provided{$c_key};}
    sub is_provided  { my ($c_key) = @_; return exists $provided{$c_key}; }

    sub init_connection {
        my ($o_key) = @_;
        unless (exists $connected{$o_key}) { $connected{$o_key} = []; }
        
        return $connected{$o_key};
    }
    
    sub get_connections {
        my ($o_key) = @_;
        
        return $connected{$o_key};
    }
    
    sub _get_class_key {
        my ($class, $typ, $name) = @_;
        
        return sprintf('%s__%s__%s', $class, $typ, $name);
    }
    
    sub _get_object_key {
        my ($obj, $typ, $name) = @_;
        
        my $id = refaddr($obj);
        my $class = ref($obj);
        
        my $c_key = _get_class_key($class, $typ, $name);
        
        return sprintf('%s__%s',$id, $c_key);
    }
}

sub SIGNAL () { return 'SIGNAL'; }; 
sub SLOT   () { return 'SLOT';   }

sub PROVIDE ($$;\&) {
    my ($typ, $name, $func_ref) = @_;
    
    my $paket = (caller(0))[0];
    
    if ($typ eq SIGNAL) {
        $func_ref = \&EMIT;
    }
    elsif ($typ eq SLOT) {
        if (not $func_ref) { die "keine Funktion definiert\n"; }
    }    
    else {
        die "Typ weder SIGNAL noch SLOT \n";
    }
    
    my $c_key = _get_class_key($paket, $typ, $name);
    
    if (not is_provided($c_key)) {
        set_provided($c_key, $func_ref);
    }
}

sub CONNECT ($$$$$$) {
    my ($sig, $sig_typ, $sig_name, $slo, $slo_typ, $slo_name) = @_;
    
    if (not blessed($sig) ) {
        say 'Erster Verbindungspartner kein Objekt';
        die;
    }

    if ($sig_typ ne SIGNAL) {
        say 'Erster Verbindungspartner nicht vom Typ SIGNAL';
        die;
    }
    
    my $sig_class = ref $sig;
    my $sig_c_key = _get_class_key($sig_class, $sig_typ, $sig_name);
    
    if (not is_provided($sig_c_key)) {
        say "Erster Verbindungspartner $sig_name nicht definiert";
        die;
    }
    
    if (not blessed($slo) ) {
        say "Zweiter Verbindungspartner kein Objekt";
        die;
    }
    
    if (($slo_typ ne SIGNAL) and ($slo_typ ne SLOT)) {
        say 'Zweiter Verbindungspartner nicht vom Typ SLOT bzw. SIGNAL';
        die;
    }
    
    my $slo_class = ref $slo;
    my $slo_c_key = _get_class_key($slo_class, $slo_typ, $slo_name);
    
    if (not is_provided($slo_c_key)) {
        say "Zweiter Verbindungspartner $slo_name nicht definiert";
        die;
    }
    
    my $sig_o_key = _get_object_key($sig, $sig_typ, $sig_name);
    
    my $connections_ref = init_connection($sig_o_key);
    
    for my $pair_ref (@$connections_ref) {
        my ($obj, undef, undef, $key) = @$pair_ref;
        return if (($obj == $slo) and ($key eq $slo_c_key));
    }
    
    push @$connections_ref, [$slo, $slo_typ, ,$slo_name, $slo_c_key];
}

sub DISCONNECT ($$$$$$) {
    my ($sig, $sig_typ, $sig_name, $slo, $slo_typ, $slo_name) = @_;
    
    if (not blessed($sig) ) {
        say 'Erster Verbindungspartner kein Objekt';
        die;
    }

    if ($sig_typ ne SIGNAL) {
        say 'Erster Verbindungspartner nicht vom Typ SIGNAL';
        die;
    }
    
    my $sig_class = ref $sig;
    my $sig_c_key = _get_class_key($sig_class, $sig_typ, $sig_name);
    
    if (not is_provided($sig_c_key)) {
        say "Erster Verbindungspartner $sig_name nicht definiert";
        die;
    }
    
    if (not blessed($slo) ) {
        say "Zweiter Verbindungspartner kein Objekt";
        die;
    }
    
    if (($slo_typ ne SIGNAL) and ($slo_typ ne SLOT)) {
        say 'Zweiter Verbindungspartner nicht vom Typ SLOT bzw. SIGNAL';
        die;
    }
    
    my $slo_class = ref $slo;
    my $slo_c_key = _get_class_key($slo_class, $slo_typ, $slo_name);
    
    if (not is_provided($slo_c_key)) {
        say "Zweiter Verbindungspartner $slo_name nicht definiert";
        die;
    }
    
    my $sig_o_key = _get_object_key($sig, $sig_typ, $sig_name);
    
    my $connections_ref = init_connection($sig_o_key);
    
    my @remain;
    for my $pair_ref (@$connections_ref) {
        my ($obj, undef, undef, $key) = @$pair_ref;
        next if (($obj == $slo) and ($key eq $slo_c_key));
        push @remain, $pair_ref;
    }
    
    @$connections_ref = @remain;
}

sub EMIT ($$;@) {
    my ($obj, $name, @args) = @_;
    
    if (not blessed($obj)) {
        say "Erstes Argument kein Objekt";
        die;
    }
    my $class = ref($obj);
    my $c_key = _get_class_key($class, SIGNAL, $name);
    if (not is_provided($c_key)) {
        say "$class $name nicht als Signal definiert";
        die;
    }
    
    my $o_key = _get_object_key($obj, SIGNAL, $name);
    
    my $connections_ref = get_connections($o_key);
    
    for my $pair_ref (@$connections_ref) {
        my ($s_obj, $s_typ, $s_name, $s_key) = @$pair_ref;
        
        my $func_ref = get_provided($s_key);
        
        if ($s_typ eq SIGNAL) {
            $func_ref->($s_obj, $s_name, @args);
        }
        else {
            $func_ref->($s_obj, @args);
        }
    }
}



1;