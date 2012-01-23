package jitensyaman::Schema::Result::Jitensyamanaccount;

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

jitensyaman::Schema::Result::Jitensyamanaccount

=cut

__PACKAGE__->table("JITENSYAMANACCOUNT");

=head1 ACCESSORS

=head2 id_field

  data_type: 'integer'
  is_nullable: 0

=head2 weight

  data_type: 'float'
  default_value: 50
  is_nullable: 0

=head2 continuerecord

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=head2 continuerecorddate

  data_type: 'date'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_field",
  { data_type => "integer", is_nullable => 0 },
  "weight",
  { data_type => "float", default_value => 50, is_nullable => 0 },
  "continuerecord",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
  "continuerecorddate",
  { data_type => "date", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id_field");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-06-05 09:03:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yS3VJpI/fc5P6b0VkD1v1w


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
