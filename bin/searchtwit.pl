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

BEGIN {
    my $lib = Path::Class::File->new(__FILE__)->parent->parent->subdir('lib');
    unshift @INC, $lib->absolute->stringify;
}
use sorosorocurrytabetai::Api::SorosorocurrytabetaiTwit;
use sorosorocurrytabetai::Api::SorosorocurrytabetaiSearch;
use sorosorocurrytabetai::Schema;

my $schema = sorosorocurrytabetai::Schema->connection(
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

my $twitschema = sorosorocurrytabetai::Api::SorosorocurrytabetaiTwit->new();
my $searchschema = sorosorocurrytabetai::Api::SorosorocurrytabetaiSearch->new();

my @twits = $twitschema->all($schema->resultset('SorosorocurrytabetaiTwit'));
foreach my $twit ( @twits ){
	my $twitter = Net::Twitter->new(
		traits => [qw/API::REST API::Search OAuth WrapError/],
		consumer_key    => 'CIsvztg5A1Bh7qZsaNbBg',
		consumer_secret => 'LmXEH6QLRwmT8XPWvYgWMstGcLj1gDf0gwcD04Aab4',
		ssl => 1,
	);
	my $since_id = (defined $twit->search_id )
		? $twit->search_id->since_id : 0;
	my $lastfind_date;
	my $twit_flag = 0;
	my $skip_flag = 0;
	my $response = $twitter->search({ q => $twit->keyword . ' from:' . $twit->user_id_field->twitter_user, since_id => $since_id });
	if ( defined $response->{results}[0] ) {
		$lastfind_date = DateTime::Format::DateParse->parse_datetime($response->{results}[0]->{created_at});
		$lastfind_date->set_time_zone('local');
		$searchschema->update_or_new(
			$schema->resultset('SorosorocurrytabetaiSearch'),
			$twit->id,
			DateTime::Format::MySQL->format_datetime( $lastfind_date ),
			$response->{results}[0]->{text},
			$response->{results}[0]->{id},
		);
		if( $twit->twit_count ) {
			$twitschema->updateTwitcountById( $schema->resultset('SorosorocurrytabetaiTwit'), $twit->id, 0);
		}
	} elsif ( $twit->twit_count ) {
		$skip_flag = 1;
	} elsif (defined $twit->search_id) {
		$lastfind_date = DateTime::Format::DateParse->parse_datetime($twit->search_id->lastfind_date);
	} else {
		$twit_flag = 1;
	}
	
	if ( !$twit_flag && !$skip_flag) {
		$lastfind_date->add( days => $twit->period );
		if ( $lastfind_date < DateTime->now( time_zone=>'local' ) ) {
			$twit_flag = 1;
		}
	}
	
	if ( $twit_flag && !$skip_flag) {
		$twitter->access_token       ( $twit->user_id_field->twitter_access_token );
		$twitter->access_token_secret( $twit->user_id_field->twitter_access_token_secret );
		$twitter->update($twit->message . " http://t.co/AbISQ2F");
		$twitschema->updateTwitcountById( $schema->resultset('SorosorocurrytabetaiTwit'), $twit->id, 1);
		print DateTime::Format::MySQL->format_datetime( DateTime->now( time_zone=>'local' ) ) . " @" . $twit->user_id_field->twitter_user . ":" . $twit->message . "\n";
	}
}

