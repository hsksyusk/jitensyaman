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
use sorosorocurrytabetai::Api::SorosorocurrytabetaiTimeline;
use sorosorocurrytabetai::Schema;


print "timeline.pl start at " . DateTime->now( time_zone=>'local' ) . "\n";

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

my $twitter = Net::Twitter->new(
	traits => [qw/API::REST API::Search OAuth WrapError/],
	consumer_key    => 'CIsvztg5A1Bh7qZsaNbBg',
	consumer_secret => 'LmXEH6QLRwmT8XPWvYgWMstGcLj1gDf0gwcD04Aab4',
	ssl => 1,
);

my $twitschema = sorosorocurrytabetai::Api::SorosorocurrytabetaiTwit->new();
my $searchschema = sorosorocurrytabetai::Api::SorosorocurrytabetaiSearch->new();
my $timelineschema = sorosorocurrytabetai::Api::SorosorocurrytabetaiTimeline->new();

my @twits = $twitschema->all($schema->resultset('SorosorocurrytabetaiTwit'));
#my @twits = $twitschema->getById_field($schema->resultset('SorosorocurrytabetaiTwit'),177);
foreach my $curry_twit ( @twits ){
#	print "foreach id=" . $curry_twit->id . " at " . DateTime->now( time_zone=>'local' ) . "\n";

	$twitter->access_token       ( $curry_twit->user_id_field->twitter_access_token );
	$twitter->access_token_secret( $curry_twit->user_id_field->twitter_access_token_secret );
	
	my $keyword = $curry_twit->keyword;

	my $lastfind_date = ( defined $curry_twit->search_id ) 
		? DateTime::Format::DateParse->parse_datetime($curry_twit->search_id->lastfind_date) : 0;
	my $find_flag = 0;
	my $page = 1;

	my $timelinebysince;
	my $timelinebydate;
	if ( defined $curry_twit->timeline_id ) {
		$timelinebysince = $curry_twit->timeline_id->since_id;
	} else {
		$timelinebydate = ( $curry_twit->period < 7 )
			? DateTime->now( time_zone=>'local' )->subtract( days => $curry_twit->period ) : DateTime->now( time_zone=>'local' )->subtract( days => 7 );
	}

	while (){
#		print "  while page=" . $page . " at " . DateTime->now( time_zone=>'local' ) . "\n";
#		print "    user_timeline start at " . DateTime->now( time_zone=>'local' ) . "\n";
		my $mytweets;
		if ( defined $timelinebysince ) {
			$mytweets = $twitter->user_timeline({
				page => $page,
				since_id => $timelinebysince,
			});
		} elsif( defined $timelinebydate ) {
			$mytweets = $twitter->user_timeline({
				page => $page,
				since => $timelinebydate,
			});
		} else {
			print "parameter not defined. twit_ID=" . $curry_twit->id . "\n";
			last;
		}

		last if (!defined $mytweets->[0]);

		if ( $page == 1 ) {
#			print "    timeline update_or_new start at " . DateTime->now( time_zone=>'local' ) . "\n";
			$timelineschema->update_or_new(
				$schema->resultset('SorosorocurrytabetaiTimeline'),
				$curry_twit->id,
				$mytweets->[0]->{id},
			);
		}

#		print "    match start at " . DateTime->now( time_zone=>'local' ) . "\n";
		my @matchs = grep ( $_->{text}=~/\Q$keyword/i , @$mytweets );
		if (defined $matchs[0] ) {
			$lastfind_date = DateTime::Format::DateParse->parse_datetime($matchs[0]->{created_at});
			$lastfind_date->set_time_zone('local');
			$searchschema->update_or_new(
				$schema->resultset('SorosorocurrytabetaiSearch'),
				$curry_twit->id,
				DateTime::Format::MySQL->format_datetime( $lastfind_date ),
				$matchs[0]->{text},
				$matchs[0]->{id},
			);
			if( $curry_twit->twit_count ) {
				$twitschema->updateTwitcountById( $schema->resultset('SorosorocurrytabetaiTwit'), $curry_twit->id, 0);
			}
			$find_flag = 1;
			last;
		} 
		$page++;
	}

#	print "check_tweet start at " . DateTime->now( time_zone=>'local' ) . "\n";
	if ( $find_flag or !$curry_twit->twit_count ) {
		if ( $lastfind_date ) {
			if ( $lastfind_date->add( days => $curry_twit->period ) < DateTime->now( time_zone=>'local' ) ) {
				$twitter->update($curry_twit->message . " http://t.co/AbISQ2F");
				$twitschema->updateTwitcountById( $schema->resultset('SorosorocurrytabetaiTwit'), $curry_twit->id, 1);
				print DateTime::Format::MySQL->format_datetime( DateTime->now( time_zone=>'local' ) ) . " @" . $curry_twit->user_id_field->twitter_user . ":" . $curry_twit->message . "\n";
			}
		} else {
			$twitter->update($curry_twit->message . " http://t.co/AbISQ2F");
			$twitschema->updateTwitcountById( $schema->resultset('SorosorocurrytabetaiTwit'), $curry_twit->id, 1);
			print DateTime::Format::MySQL->format_datetime( DateTime->now( time_zone=>'local' ) ) . " @" . $curry_twit->user_id_field->twitter_user . ":" . $curry_twit->message . "\n";
		}
	}

}

print "timeline.pl end at " . DateTime->now( time_zone=>'local' ) . "\n";
