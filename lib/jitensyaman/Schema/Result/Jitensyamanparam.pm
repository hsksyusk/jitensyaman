package jitensyaman::Schema::Result::Jitensyamanparam;

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

jitensyaman::Schema::Result::Jitensyamanparam

=cut

__PACKAGE__->table("JITENSYAMANPARAM");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sinceid

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sinceid",
  { data_type => "bigint", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-27 19:51:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hKFvDAn/TjI2/YCMjQP5dg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
