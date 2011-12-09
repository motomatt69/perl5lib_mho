package AddressBook::Schema::AddressDB::People;

# Created by DBIx::Class::Schema::Loader v0.03009 @ 2006-12-10 21:20:12

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("people");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "firstname",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
  "lastname",
  { data_type => "VARCHAR", is_nullable => 0, size => 50 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(addresses => 'AddressBook::Schema::AddressDB::Addresses',
		      'person', {cascading_delete => 1});

__PACKAGE__->add_unique_constraint(name => [qw/firstname lastname/]);

sub name {
    my $self = shift;
    return $self->firstname. ' '. $self->lastname;
}

1;
