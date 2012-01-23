package jitensyaman::Schema::Result::Jitensyamantrackstotal;

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

jitensyaman::Schema::Result::Jitensyamantrackstotal

=cut

__PACKAGE__->table("JITENSYAMANTRACKSTOTAL");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 id_field

  data_type: 'integer'
  is_nullable: 0

=head2 create_date

  data_type: 'datetime'
  is_nullable: 0

=head2 update_date

  data_type: 'datetime'
  is_nullable: 0

=head2 life

  data_type: 'tinyint'
  is_nullable: 1

=head2 year

  data_type: 'integer'
  is_nullable: 1

=head2 month

  data_type: 'integer'
  is_nullable: 1

=head2 distance

  data_type: 'float'
  is_nullable: 1

=head2 time

  data_type: 'float'
  is_nullable: 1

=head2 elevation

  data_type: 'float'
  is_nullable: 1

=head2 speed

  data_type: 'float'
  is_nullable: 1

=head2 speedmax

  data_type: 'float'
  is_nullable: 1

=head2 cadence

  data_type: 'integer'
  is_nullable: 1

=head2 cadencemax

  data_type: 'integer'
  is_nullable: 1

=head2 power

  data_type: 'integer'
  is_nullable: 1

=head2 powermax

  data_type: 'integer'
  is_nullable: 1

=head2 heartrate

  data_type: 'integer'
  is_nullable: 1

=head2 heartratemax

  data_type: 'integer'
  is_nullable: 1

=head2 calorie

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "id_field",
  { data_type => "integer", is_nullable => 0 },
  "create_date",
  { data_type => "datetime", is_nullable => 0 },
  "update_date",
  { data_type => "datetime", is_nullable => 0 },
  "life",
  { data_type => "tinyint", is_nullable => 1 },
  "year",
  { data_type => "integer", is_nullable => 1 },
  "month",
  { data_type => "integer", is_nullable => 1 },
  "distance",
  { data_type => "float", is_nullable => 1 },
  "time",
  { data_type => "float", is_nullable => 1 },
  "elevation",
  { data_type => "float", is_nullable => 1 },
  "speed",
  { data_type => "float", is_nullable => 1 },
  "speedmax",
  { data_type => "float", is_nullable => 1 },
  "cadence",
  { data_type => "integer", is_nullable => 1 },
  "cadencemax",
  { data_type => "integer", is_nullable => 1 },
  "power",
  { data_type => "integer", is_nullable => 1 },
  "powermax",
  { data_type => "integer", is_nullable => 1 },
  "heartrate",
  { data_type => "integer", is_nullable => 1 },
  "heartratemax",
  { data_type => "integer", is_nullable => 1 },
  "calorie",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-27 19:51:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lsopN9Q92F4GfrlypATZEw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
