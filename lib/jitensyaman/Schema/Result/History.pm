package jitensyaman::Schema::Result::History;

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

jitensyaman::Schema::Result::History

=cut

__PACKAGE__->table("HISTORY");

=head1 ACCESSORS

=head2 userid

  data_type: 'integer'
  is_nullable: 0

=head2 ranking_update

  data_type: 'datetime'
  is_nullable: 0

=head2 ranking_create

  data_type: 'datetime'
  is_nullable: 1

=head2 draft_flag

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "integer", is_nullable => 0 },
  "ranking_update",
  { data_type => "datetime", is_nullable => 0 },
  "ranking_create",
  { data_type => "datetime", is_nullable => 1 },
  "draft_flag",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("userid");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1g82YDm+/mxH5MGiMUMpKg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
