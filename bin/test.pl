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
use YAML::Tiny;
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

my $tweet_messages = (YAML::Tiny->read('tweet.yml'))->[0];


#if ( $TODAY->day == 1 && $TODAY->hour == 11 && 56 < $TODAY->minute && $TODAY->minute < 60 ) {
if ( $TODAY->day == 30 && $TODAY->hour == 19 && 5 < $TODAY->minute && $TODAY->minute < 60 ) {

	my $firstday_of_lastmonth = DateTime::Format::MySQL->format_date( DateTime->new( year => $YESTARDAY->year, month => $YESTARDAY->month, day => 1 ) );
	my $lastday_of_lastmonth = DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $YESTARDAY->year, month => $YESTARDAY->month ) );

	my $monthusers = $trackschema->getUsersByMonth(
		$schema->resultset('Jitensyamantrack'),
		$firstday_of_lastmonth,
		$lastday_of_lastmonth,
	);
	foreach my $userid_month ( $monthusers->next ) {
		my $username_month = $userschema->getTwitteruserById(
				$schema->resultset('Jitensyamanuser'),
				$userid_month->id_field,
		);
		my $mytracks = $trackschema->getTracksByTerm(
			$schema->resultset('Jitensyamantrack'),
			$userid_month->id_field,
			$firstday_of_lastmonth,
			$lastday_of_lastmonth,
		);
		my $mytracks_count = $trackschema->getTrackscountByTerm(
			$schema->resultset('Jitensyamantrack'),
			$userid_month->id_field,
			$firstday_of_lastmonth,
			$lastday_of_lastmonth,
		);

		my $tweet_message_of_lastmonth = "@" . $username_month . " ！先月の走行記録だ！" . $mytracks_count . "日走ってるな";
		
		my $max_length = 110;
		if ( $mytracks->get_column('sum_distance') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、総走行距離は%dkm",$mytracks->get_column('sum_distance') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_distance') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均走行距離は%dkm",$mytracks->get_column('avg_distance') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('sum_time') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、総走行時間は%d時間",$mytracks->get_column('sum_time') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_time') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均走行時間は%.1f時間",$mytracks->get_column('avg_time') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('sum_elevation') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、総累計標高は%dm",$mytracks->get_column('sum_elevation') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_elevation') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均累計標高は%dm",$mytracks->get_column('avg_elevation') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_speed') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均速度は%.1fkm/h",$mytracks->get_column('avg_speed') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('max_speedmax') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、最高速度は%dkm/h",$mytracks->get_column('max_speedmax') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_cadence') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均ケイデンスは%drpm",$mytracks->get_column('avg_cadence') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('max_cadencemax') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、最高ケイデンスは%drpm",$mytracks->get_column('max_cadencemax') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_power') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均出力は%dW",$mytracks->get_column('avg_power') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('max_powermax') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、最大出力は%dW",$mytracks->get_column('max_powermax') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_heartrate') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均心拍数は%dbpm",$mytracks->get_column('avg_heartrate') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('max_heartratemax') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、最大心拍数は%dbpm",$mytracks->get_column('max_heartratemax') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('sum_calorie') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、総消費カロリーは%dkcal",$mytracks->get_column('sum_calorie') ); }
		$tweet_message_of_lastmonth = &check_tweet_long( $tweet_message_of_lastmonth, $max_length, $username_month );
		if ( $mytracks->get_column('avg_calorie') > 0 ) { $tweet_message_of_lastmonth = $tweet_message_of_lastmonth . sprintf("、平均消費カロリーは%dkcal",$mytracks->get_column('avg_calorie') ); }
		$tweet_message_of_lastmonth = $tweet_message_of_lastmonth . "だ！";
#		$twitter->update($tweet_message_of_lastmonth);
		print $tweet_message_of_lastmonth . "\n";
	}
}

if ( 56 < $TODAY->minute && $TODAY->minute < 60 ) {
	print $tweet_messages->{'reply'}[int( rand(@{$tweet_messages->{'reply'}}) )] . "\n";
	print $tweet_messages->{'tweet'}[int( rand(@{$tweet_messages->{'tweet'}}) )] . "\n";
}

sub check_tweet_long(){
	my ( $tweet_message, $max_length, $username ) = @_;
	if (length($tweet_message) >= $max_length ){
#		$twitter->update( $tweet_message . "だ！続くぞ！");
		print $tweet_message . "だ！続くぞ！" . "\n";
		$tweet_message = "やあ @" . $username . " ！続きだ";
	}
	return $tweet_message;
}
