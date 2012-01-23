package jitensyaman::Schema::Result::WpUser;

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

jitensyaman::Schema::Result::WpUser

=cut

__PACKAGE__->table("wp_users");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_login

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 60

=head2 user_pass

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 user_nicename

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 50

=head2 user_email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 user_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 100

=head2 user_registered

  data_type: 'datetime'
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 user_activation_key

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 60

=head2 user_status

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 display_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 250

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "user_login",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 60 },
  "user_pass",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "user_nicename",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 50 },
  "user_email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "user_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 100 },
  "user_registered",
  {
    data_type     => "datetime",
    default_value => "0000-00-00 00:00:00",
    is_nullable   => 0,
  },
  "user_activation_key",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 60 },
  "user_status",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "display_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 250 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TyzIGiH2nFaI0ifMhh8ytg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
