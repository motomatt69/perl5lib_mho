package MyApp::Schema::Result::Book;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

MyApp::Schema::Result::Book

=cut

__PACKAGE__->table("book");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 rating

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "rating",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 book_authors

Type: has_many

Related object: L<MyApp::Schema::Result::BookAuthor>

=cut

__PACKAGE__->has_many(
  "book_authors",
  "MyApp::Schema::Result::BookAuthor",
  { "foreign.book_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-04-22 20:48:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L24HJl+lKz3gD3Xe63aopw


__PACKAGE__->many_to_many(authors => 'book_authors', 'author');
1;
