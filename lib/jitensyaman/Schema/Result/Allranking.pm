package jitensyaman::Schema::Result::Allranking;

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

jitensyaman::Schema::Result::Allranking

=cut

__PACKAGE__->table("ALLRANKING");

=head1 ACCESSORS

=head2 asin

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 point

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 number_of_user

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "asin",
  { data_type => "char", is_nullable => 0, size => 10 },
  "point",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "number_of_user",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("asin");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PD4mly8bb3EXv9X5NtokGg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
