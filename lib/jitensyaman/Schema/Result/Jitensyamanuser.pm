package jitensyaman::Schema::Result::Jitensyamanuser;

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

jitensyaman::Schema::Result::Jitensyamanuser

=cut

__PACKAGE__->table("JITENSYAMANUSER");

=head1 ACCESSORS

=head2 id_field

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 twitter_user_id

  data_type: 'integer'
  is_nullable: 0

=head2 twitter_user

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 twitter_access_token

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 twitter_access_token_secret

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id_field",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "twitter_user_id",
  { data_type => "integer", is_nullable => 0 },
  "twitter_user",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "twitter_access_token",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "twitter_access_token_secret",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id_field");
__PACKAGE__->add_unique_constraint("TWITTER_USER_ID", ["twitter_user_id"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pP30k1AtiTHrXOYd+e8OtA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
