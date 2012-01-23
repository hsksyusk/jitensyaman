package jitensyaman::Schema::Result::WpPost;

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

jitensyaman::Schema::Result::WpPost

=cut

__PACKAGE__->table("wp_posts");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 post_author

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 post_date

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 post_date_gmt

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 post_content

  data_type: 'longtext'
  is_nullable: 0

=head2 post_title

  data_type: 'text'
  is_nullable: 0

=head2 post_excerpt

  data_type: 'text'
  is_nullable: 0

=head2 post_status

  data_type: 'varchar'
  default_value: 'publish'
  is_nullable: 0
  size: 20

=head2 comment_status

  data_type: 'varchar'
  default_value: 'open'
  is_nullable: 0
  size: 20

=head2 ping_status

  data_type: 'varchar'
  default_value: 'open'
  is_nullable: 0
  size: 20

=head2 post_password

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 post_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=head2 to_ping

  data_type: 'text'
  is_nullable: 0

=head2 pinged

  data_type: 'text'
  is_nullable: 0

=head2 post_modified

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 post_modified_gmt

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 post_content_filtered

  data_type: 'text'
  is_nullable: 0

=head2 post_parent

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 guid

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 menu_order

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 post_type

  data_type: 'varchar'
  default_value: 'post'
  is_nullable: 0
  size: 20

=head2 post_mime_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 comment_count

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "post_author",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "post_date",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "post_date_gmt",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "post_content",
  { data_type => "longtext", is_nullable => 0 },
  "post_title",
  { data_type => "text", is_nullable => 0 },
  "post_excerpt",
  { data_type => "text", is_nullable => 0 },
  "post_status",
  {
    data_type => "varchar",
    default_value => "publish",
    is_nullable => 0,
    size => 20,
  },
  "comment_status",
  {
    data_type => "varchar",
    default_value => "open",
    is_nullable => 0,
    size => 20,
  },
  "ping_status",
  {
    data_type => "varchar",
    default_value => "open",
    is_nullable => 0,
    size => 20,
  },
  "post_password",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "post_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
  "to_ping",
  { data_type => "text", is_nullable => 0 },
  "pinged",
  { data_type => "text", is_nullable => 0 },
  "post_modified",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "post_modified_gmt",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "post_content_filtered",
  { data_type => "text", is_nullable => 0 },
  "post_parent",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "guid",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "menu_order",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "post_type",
  {
    data_type => "varchar",
    default_value => "post",
    is_nullable => 0,
    size => 20,
  },
  "post_mime_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "comment_count",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KArF3hoBKQbiqaOfQVXKHg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
