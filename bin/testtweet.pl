#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use local::lib;
use Path::Class::File;
use Net::Twitter;
use DateTime;
use DateTime::Format::W3CDTF;
use DateTime::Format::MySQL;
use DateTime::Format::DateParse;
use Data::Dumper;
use Attribute::Constant;
use Lingua::JA::Regular::Unicode;

BEGIN {
    my $lib = Path::Class::File->new(__FILE__)->parent->parent->subdir('lib');
    unshift @INC, $lib->absolute->stringify;
}
use jitensyaman::Api::Jitensyamantrack;
use jitensyaman::Api::Jitensyamanuser;
use jitensyaman::Api::Jitensyamanparam;
use jitensyaman::Schema;

my $TODAY : Constant(DateTime->now( time_zone=>'local' ));
my $YESTARDAY : Constant(DateTime->now( time_zone=>'local' )->subtract( days => 1 ));
print "timeline.pl start at " . $TODAY . "\n";

my $schema = jitensyaman::Schema->connection(
#	'dbi:mysql:hsksyusk',
#	'root',
	'dbi:mysql:database=hsksyusk:host=mysql231.db.sakura.ne.jp',
	'hsksyusk',
	'root16',
	{
		AutoCommit => 1,
		mysql_enable_utf8 => 1,
		on_connect_do => [
			"SET NAMES utf8",
			"SET CHARACTER SET 'utf8'",
		],
	},
);
my $trackschema = jitensyaman::Api::Jitensyamantrack->new();
my $userschema = jitensyaman::Api::Jitensyamanuser->new();
my $paramschema = jitensyaman::Api::Jitensyamanparam->new();

my $twitter = Net::Twitter->new(
	traits => [qw/API::REST API::Search OAuth WrapError/],
	consumer_key    => '2uug02EU3AlD2xkf4Aug',
	consumer_secret => 'JEUOl5MjrsJ1IR8iGUIrr61ndttKINIKifddigTU8',
	ssl => 1,
);

$twitter->access_token       ( "303533795-AsJ3dwldGNnXrkwG3TPbzAeKejTvna88ldcRkUU4" );
$twitter->access_token_secret( "vtScnTvF2CE1Ef1bnJKEDWyI2iFWy1TF2G41ZtF1G0" );
	$twitter->update("テスト");
