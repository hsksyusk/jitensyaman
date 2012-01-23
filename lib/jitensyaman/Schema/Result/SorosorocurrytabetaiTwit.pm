package jitensyaman::Schema::Result::SorosorocurrytabetaiTwit;

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

jitensyaman::Schema::Result::SorosorocurrytabetaiTwit

=cut

__PACKAGE__->table("SOROSOROCURRYTABETAI_TWIT");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 id_field

  data_type: 'integer'
  is_nullable: 0

=head2 keyword

  data_type: 'varchar'
  is_nullable: 0
  size: 420

=head2 message

  data_type: 'varchar'
  is_nullable: 0
  size: 420

=head2 period

  data_type: 'integer'
  is_nullable: 0

=head2 twit_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 twit_count_set

  data_type: 'integer'
  is_nullable: 0

=head2 create_date

  data_type: 'datetime'
  is_nullable: 0

=head2 update_date

  data_type: 'datetime'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "id_field",
  { data_type => "integer", is_nullable => 0 },
  "keyword",
  { data_type => "varchar", is_nullable => 0, size => 420 },
  "message",
  { data_type => "varchar", is_nullable => 0, size => 420 },
  "period",
  { data_type => "integer", is_nullable => 0 },
  "twit_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "twit_count_set",
  { data_type => "integer", is_nullable => 0 },
  "create_date",
  { data_type => "datetime", is_nullable => 0 },
  "update_date",
  { data_type => "datetime", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yPOmEzBUstsBo2auLQfDpA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
