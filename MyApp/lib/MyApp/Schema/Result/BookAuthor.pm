package MyApp::Schema::Result::BookAuthor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

MyApp::Schema::Result::BookAuthor

=cut

__PACKAGE__->table("book_author");

=head1 ACCESSORS

=head2 book_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 author_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "book_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "author_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("book_id", "author_id");

=head1 RELATIONS

=head2 author

Type: belongs_to

Related object: L<MyApp::Schema::Result::Author>

=cut

__PACKAGE__->belongs_to(
  "author",
  "MyApp::Schema::Result::Author",
  { id => "author_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 book

Type: belongs_to

Related object: L<MyApp::Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "MyApp::Schema::Result::Book",
  { id => "book_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-04-22 20:48:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7lqTl8i48Xzpz4XJMxUifA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
