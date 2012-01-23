package jitensyaman::Schema::Result::Account;

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

jitensyaman::Schema::Result::Account

=cut

__PACKAGE__->table("ACCOUNT");

=head1 ACCESSORS

=head2 userid

  data_type: 'integer'
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 sendmail_notification

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 sendmail_comment

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 sendmail_good

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 post_twitter_create_ranking

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 post_twitter_update_ranking

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 email_auth

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 0

=head2 email_auth_key

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 email_suggest_flag

  data_type: 'tinyint'
  default_value: 1
  is_nullable: 0

=head2 create_date

  data_type: 'datetime'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "userid",
  { data_type => "integer", is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "sendmail_notification",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "sendmail_comment",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "sendmail_good",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "post_twitter_create_ranking",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "post_twitter_update_ranking",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "email_auth",
  { data_type => "tinyint", default_value => 0, is_nullable => 0 },
  "email_auth_key",
  { data_type => "char", is_nullable => 1, size => 32 },
  "email_suggest_flag",
  { data_type => "tinyint", default_value => 1, is_nullable => 0 },
  "create_date",
  { data_type => "datetime", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("userid");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6RXgXeNYE5a6N1rkgy2i1w


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
