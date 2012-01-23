package jitensyaman::Schema::Result::WpComment;

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

jitensyaman::Schema::Result::WpComment

=cut

__PACKAGE__->table("wp_comments");

=head1 ACCESSORS

=head2 comment_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 comment_post_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 comment_author

  data_type: 'tinytext'
  is_nullable: 0

=head2 comment_author_email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 comment_author_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 200

=head2 comment_author_ip

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 comment_date

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 comment_date_gmt

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 comment_content

  data_type: 'text'
  is_nullable: 0

=head2 comment_karma

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 comment_approved

  data_type: 'varchar'
  default_value: 1
  is_nullable: 0
  size: 20

=head2 comment_agent

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 comment_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=head2 comment_parent

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "comment_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "comment_post_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "comment_author",
  { data_type => "tinytext", is_nullable => 0 },
  "comment_author_email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "comment_author_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 200 },
  "comment_author_ip",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "comment_date",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "comment_date_gmt",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "comment_content",
  { data_type => "text", is_nullable => 0 },
  "comment_karma",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "comment_approved",
  { data_type => "varchar", default_value => 1, is_nullable => 0, size => 20 },
  "comment_agent",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "comment_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
  "comment_parent",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("comment_id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HECsHQXMyWQUTfqpmRiXBQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
