package jitensyaman::Schema::Result::WpUsermeta;

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

jitensyaman::Schema::Result::WpUsermeta

=cut

__PACKAGE__->table("wp_usermeta");

=head1 ACCESSORS

=head2 umeta_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 meta_key

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 meta_value

  data_type: 'longtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "umeta_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "bigint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "meta_key",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "meta_value",
  { data_type => "longtext", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("umeta_id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ydTaMKljvLgucA+mum40OA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
