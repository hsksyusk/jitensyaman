package jitensyaman::Schema::Result::WpTermTaxonomy;

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

jitensyaman::Schema::Result::WpTermTaxonomy

=cut

__PACKAGE__->table("wp_term_taxonomy");

=head1 ACCESSORS

=head2 term_taxonomy_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 term_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 taxonomy

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 description

  data_type: 'longtext'
  is_nullable: 0

=head2 parent

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 count

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "term_taxonomy_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "term_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "taxonomy",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "description",
  { data_type => "longtext", is_nullable => 0 },
  "parent",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "count",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("term_taxonomy_id");
__PACKAGE__->add_unique_constraint("term_id_taxonomy", ["term_id", "taxonomy"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kUbICwr39iM2vfK6KZOebA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
