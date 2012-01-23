package jitensyaman::Schema::Result::WpLink;

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

jitensyaman::Schema::Result::WpLink

=cut

__PACKAGE__->table("wp_links");

=head1 ACCESSORS

=head2 link_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 link_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 link_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 link_image

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 link_target

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 25

=head2 link_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 link_visible

  data_type: 'varchar'
  default_value: 'Y'
  is_nullable: 0
  size: 20

=head2 link_owner

  data_type: 'bigint'
  default_value: 1
  extra: {unsigned => 1}
  is_nullable: 0

=head2 link_rating

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 link_updated

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 link_rel

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 link_notes

  data_type: 'mediumtext'
  is_nullable: 0

=head2 link_rss

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "link_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "link_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "link_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "link_image",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "link_target",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 25 },
  "link_description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "link_visible",
  { data_type => "varchar", default_value => "Y", is_nullable => 0, size => 20 },
  "link_owner",
  {
    data_type => "bigint",
    default_value => 1,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "link_rating",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "link_updated",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "link_rel",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "link_notes",
  { data_type => "mediumtext", is_nullable => 0 },
  "link_rss",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("link_id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PDGrx1H8G3A7WdPSMX5kSg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
