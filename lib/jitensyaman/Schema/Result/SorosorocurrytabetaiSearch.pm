package jitensyaman::Schema::Result::SorosorocurrytabetaiSearch;

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

jitensyaman::Schema::Result::SorosorocurrytabetaiSearch

=cut

__PACKAGE__->table("SOROSOROCURRYTABETAI_SEARCH");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 lastfind_date

  data_type: 'datetime'
  is_nullable: 0

=head2 lastfind_text

  data_type: 'varchar'
  is_nullable: 0
  size: 420

=head2 since_id

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "lastfind_date",
  { data_type => "datetime", is_nullable => 0 },
  "lastfind_text",
  { data_type => "varchar", is_nullable => 0, size => 420 },
  "since_id",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V+RQndE0V5FFu5Jv5OOdJQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
