package jitensyaman::Schema::Result::WpTermRelationship;

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

jitensyaman::Schema::Result::WpTermRelationship

=cut

__PACKAGE__->table("wp_term_relationships");

=head1 ACCESSORS

=head2 object_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 term_taxonomy_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 term_order

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "object_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "term_taxonomy_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "term_order",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("object_id", "term_taxonomy_id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z8i6++i6/GN+jaKyQphx0g


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
