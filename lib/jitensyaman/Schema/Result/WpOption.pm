package jitensyaman::Schema::Result::WpOption;

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

jitensyaman::Schema::Result::WpOption

=cut

__PACKAGE__->table("wp_options");

=head1 ACCESSORS

=head2 option_id

  data_type: 'bigint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 blog_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 option_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 64

=head2 option_value

  data_type: 'longtext'
  is_nullable: 0

=head2 autoload

  data_type: 'varchar'
  default_value: 'yes'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "option_id",
  {
    data_type => "bigint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "blog_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "option_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 64 },
  "option_value",
  { data_type => "longtext", is_nullable => 0 },
  "autoload",
  {
    data_type => "varchar",
    default_value => "yes",
    is_nullable => 0,
    size => 20,
  },
);
__PACKAGE__->set_primary_key("option_id");
__PACKAGE__->add_unique_constraint("option_name", ["option_name"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-05-26 22:32:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:13fVHk1Tc3Q6NePauo0oHw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
