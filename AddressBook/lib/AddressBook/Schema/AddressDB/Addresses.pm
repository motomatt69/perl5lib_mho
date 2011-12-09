package AddressBook::Schema::AddressDB::Addresses;

# Created by DBIx::Class::Schema::Loader v0.03009 @ 2006-12-10 21:20:12

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("PK::Auto", "Core");
__PACKAGE__->table("addresses");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "person",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "location",
  { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "postal",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "phone",
  { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "email",
  { data_type => "VARCHAR", is_nullable => 0, size => 100 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(person => 'AddressBook::Schema::AddressDB::People');

1;

