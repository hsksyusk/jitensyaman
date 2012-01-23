package jitensyaman::Schema::Result::WpTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

jitensyaman::Schema::Result::WpTerm

=cut

__PACKAGE__->table("wp_terms");

=head1 ACCESSORS

=head2 term_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=head2 slug

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=head2 term_group

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
  "slug",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
  "term_group",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_id");
__PACKAGE__->add_unique_constraint("slug", ["slug"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+IJTHNJjr8lSD7DcqY/5mA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
