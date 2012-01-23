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
my $LASTMONTH : Constant(DateTime->now( time_zone=>'local' )->subtract( months => 1 ));
my $LASTYEAR : Constant(DateTime->now( time_zone=>'local' )->subtract( years => 1 ));

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

my $tweet_messages = (YAML::Tiny->read('/home/hsksyusk/app/jitensyaman/bin/tweet.yml'))->[0];

my $since_id = $paramschema->getSinceid($schema->resultset('Jitensyamanparam'));
my $page = 1;
while (){
	my $mentions = $twitter->mentions({ page => $page, since_id => $since_id });
	last if (!defined $mentions->[0]);

	if ( $page == 1 ) {
		print "checkmentions.pl start at " . $TODAY . "\n";
		print "since_id = " . $mentions->[0]->{id} . "\n";
		$paramschema->updateSinceid(
			$schema->resultset('Jitensyamanparam'),
			$mentions->[0]->{id},
		);
	}

	foreach my $mention ( @$mentions ){
		my $data_line = $mention->{text};

=comment
	open(FH,"<:utf8","check.txt");
	my @list = <FH>;
	foreach my $data_line ( @list ) {
=cut

		my $userid = $userschema->getUserid(
				$schema->resultset('Jitensyamanuser'),
				$mention->{user}->{id},
				$mention->{user}->{screen_name},
		);
		my $username = $mention->{user}->{screen_name};
=comment
		my $userid = 1;
		my $username = "hsksyusk";
=cut
		$data_line = alnum_z2h($data_line);
		print $data_line . "\n";
		
		if ($data_line =~ /(違う|ちがう|チガウ|間違えた|まちがえた|マチガエタ)/ ){
			my $lastupdate_date = $trackschema->deleteLastUpdateByUser(
				$schema->resultset('Jitensyamantrack'),
				$userid,
			);
			my $delete_message = "@" . $username . " ！" . DateTime::Format::DateParse->parse_datetime($lastupdate_date)->strftime('%Y/%m/%d') . "に走った記録は間違っていたようだな。その記録は忘れよう。";
			$twitter->update($delete_message);
			print $delete_message . "\n";
		} else {
			my %track;
			my %calc_flag;
			$track{'tweet'} = $data_line;
			if ($data_line =~ s/((?:19|20)?[0-9]{2})(?:年|\/)(1[0-2]|0?[1-9])(?:月|\/)([12][0-9]|3[01]|0?[1-9])//i ){
				my $year =  ( $1 < 1900 )
					? $1 + 2000 : $1;
				$track{'date'} = &make_date1($year,$2,$3);
#				print "data_line=" . $data_line . "\n";
			} elsif ($data_line =~ s/(1[0-2]|0?[1-9])(?:月|\/)([12][0-9]|3[01]|0?[1-9])//i ){
				$track{'date'} = &make_date1(0,$1,$2);
#				print "data_line=" . $data_line . "\n";
			} elsif ($data_line =~ s/([12][0-9]|3[01]|0?[1-9])日//i ){
				$track{'date'} = &make_date1(0,0,$1);
#				print "data_line=" . $data_line . "\n";
			} elsif ($data_line =~ s/(今日|きょう|today|おととい|一昨日|昨日|きのう|yestarday)//i ){
				$track{'date'} = &make_date2($1);
#				print "data_line=" . $data_line . "\n";
			} elsif ($data_line =~ s/((?:19|20)?[0-9]{2})(?:年|\/)(1[0-2]|0?[1-9])//i ){
				$track{'year'} =  ( $1 < 1900 )
					? $1 + 2000 : $1;
				$track{'month'} = $2;
			} elsif ($data_line =~ s/(1[0-2]|0?[1-9])月//i ){
				$track{'month'} = $1;
			} elsif ($data_line =~ s/((?:19|20)?[0-9]{2})年//i ){
				$track{'year'} =  ( $1 < 1900 )
					? $1 + 2000 : $1;
			} elsif ($data_line =~ s/今月//i ){
				$track{'year'} = $TODAY->year;
				$track{'month'} = $TODAY->month;
			} elsif ($data_line =~ s/今年//i ){
				$track{'year'} = $TODAY->year;
			} elsif ($data_line =~ s/先月//i ){
				$track{'year'} = $LASTMONTH->year;
				$track{'month'} = $LASTMONTH->month;
			} elsif ($data_line =~ s/去年|昨年//i ){
				$track{'year'} = $LASTYEAR->year;
			}

			if ( $data_line =~ /記録/ ){
				$track{'checkrecord_flag'} = 1;
			} else {

				if ($data_line =~ s/(?:距離|distance).{0,5}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)?//i ){
					$track{'distance'} = &make_distance($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(\d)(?:時間|h|hour|:)([0-5][0-9])(?:分|m|min|:)?([0-5][0-9])?//i ){
					$track{'time'} = &make_time1($1,$2,$3);
#					print "data_line=" . $data_line . "\n\n";
				} elsif ($data_line =~ s/(\d+\.?\d?)(時間|h|hour|分|min)//i ){
					$track{'time'} = &make_time2($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:標高|elevation).{0,5}?(\d+\.?\d?).{0,3}?(m|feet)?//i ){
					$track{'elevation'} = &make_elevation($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:最高|最大|MAX).{0,3}?時速.{0,3}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)?//i ){
					$track{'speedmax'} = &make_speed($1,$2,"/h");
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:速度|speed).{0,3}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)(\/h|毎時)?//i ){
					$track{'speedmax'} = &make_speed($1,$2,$3);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:速度|speed)?.{0,3}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)(\/h|毎時)//i ){
					$track{'speedmax'} = &make_speed($1,$2,$3);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:速度|speed)?.{0,3}?(\d+\.?\d?).{0,3}?mph//i ){
					$track{'speedmax'} = &make_speed($1,"miles","/h");
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/時速.{0,3}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)?//i ){
					$track{'speed'} = &make_speed($1,$2,"/h");
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:速度|speed).{0,3}?(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)?(\/h|毎時)?//i ){
					$track{'speed'} = &make_speed($1,$2,$3);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)(\/h|毎時)//i ){
					$track{'speed'} = &make_speed($1,$2,$3);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?mph//i ){
					$track{'speed'} = &make_speed($1,"miles","/h");
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:ケイデンス|cadence|cad).{0,3}?(\d+\.?\d?).{0,3}?(rpm)?//i ){
					$track{'cadencemax'} = &make_cadence($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(\d+\.?\d?).{0,3}?(rpm)//i ){
					$track{'cadencemax'} = &make_cadence($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:ケイデンス|cadence|cad).{0,3}?(\d+\.?\d?).{0,3}?(rpm)?//i ){
					$track{'cadence'} = &make_cadence($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?(rpm)//i ){
					$track{'cadence'} = &make_cadence($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:心拍数|HR|Heartrate).{0,3}?(\d+\.?\d?).{0,3}?(bpm)?//i ){
					$track{'heartratemax'} = &make_heartrate($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(\d+\.?\d?).{0,3}?(bpm)//i ){
					$track{'heartratemax'} = &make_heartrate($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:心拍数|HR|Heartrate).{0,3}?(\d+\.?\d?).{0,3}?(bpm)?//i ){
					$track{'heartrate'} = &make_heartrate($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?(bpm)//i ){
					$track{'heartrate'} = &make_heartrate($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(?:パワー|POWER).{0,3}?(\d+\.?\d?).{0,3}?(W|ワット)?//i ){
					$track{'powermax'} = &make_power($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(?:最高|最大|MAX).{0,3}?(\d+\.?\d?).{0,3}?(W|ワット)//i ){
					$track{'powermax'} = &make_power($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:パワー|POWER).{0,3}?(\d+\.?\d?).{0,3}?(W|ワット)?//i ){
					$track{'power'} = &make_power($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?(W|ワット)//i ){
					$track{'power'} = &make_power($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ($data_line =~ s/(?:カロリー|calorie).{0,3}?(\d+\.?\d?).{0,3}?(カロリー|cal|kcal|calorie)?//i ){
					$track{'calorie'} = &make_calorie($1,$2);
#					print "data_line=" . $data_line . "\n";
				} elsif ($data_line =~ s/(\d+\.?\d?).{0,3}?(カロリー|cal|kcal|calorie)//i ){
					$track{'calorie'} = &make_calorie($1,$2);
#					print "data_line=" . $data_line . "\n";
				}
				if ( !defined $track{'distance'} ) {
					if ($data_line =~ s/(\d+\.?\d?).{0,3}?(km|mile|miles|m|キロ|キロメートル|メートル|マイル)(?!\/)//i ){
						$track{'distance'} = &make_distance($1,$2);
#						print "data_line=" . $data_line . "\n";
					}
				}
				
				# Calc empty items
				if ( !defined $track{'speed'} ) {
					if ( defined $track{'distance'} && defined $track{'time'} ){
						$track{'speed'} = &calc_speed($track{'distance'},$track{'time'});
						$calc_flag{'speed'} = 1;
					}
				}
				if ( !defined $track{'time'} ) {
					if ( defined $track{'distance'} ){
						my $speed = ( defined $track{'speed'} )
							? $track{'speed'} : 15; 
						$track{'time'} = &calc_time($track{'distance'},$speed);
						$calc_flag{'time'} = 1;
					}	
				}
				if ( !defined $track{'distance'} ) {
					if ( defined $track{'time'} ){
						my $speed = ( defined $track{'speed'} )
							? $track{'speed'} : 15; 
						$track{'distance'} = &calc_distance($track{'time'},$speed);
						$calc_flag{'distance'} = 1;
					}	
				}
				if ( !defined $track{'calorie'} && defined $track{'distance'} && defined $track{'time'} ) {
					my $speed = ( defined $track{'speed'} )
						? $track{'speed'} : 15; 
					$track{'calorie'} = &calc_calorie($track{'time'},$speed);
					$calc_flag{'calorie'} = 1;
				}
			}
			
			#regist data
#			foreach my $key ( keys %track ) {
#				print "key:$key : value:$track{$key}", "\n";
#			}

			my $tweet_message = "@" . $username . " ！";

			if ( defined $track{'distance'} or defined $track{'time'} or defined $track{'elevation'} 
				or defined $track{'speed'} or defined $track{'speedmax'} or defined $track{'cadence'} 
				or defined $track{'cadencemax'} or defined $track{'power'} or defined $track{'powermax'} 
				or defined $track{'heartrate'} or defined $track{'heartratemax'} or defined $track{'calorie'} ) {

				$track{'date'} = &make_date2("today") if (!defined $track{'date'});

				$trackschema->create( 
					$schema->resultset('Jitensyamantrack'),
					$userid,
					$track{'date'},
					$track{'distance'},
					$track{'time'},
					$track{'elevation'},
					$track{'speed'},
					$track{'speedmax'},
					$track{'cadence'},
					$track{'cadencemax'},
					$track{'power'},
					$track{'powermax'},
					$track{'heartrate'},
					$track{'heartratemax'},
					$track{'calorie'},
					$track{'tweet'},
				);

				my $tweet_max = 100;
				my $tweet_day_regist = DateTime::Format::DateParse->parse_datetime($track{'date'});
				my $tracks_month_message;
				if ( defined $track{'distance'} ) {
					my $tracks_month = $trackschema->getTracksByTerm(
						$schema->resultset('Jitensyamantrack'),
						$userid,
						DateTime::Format::MySQL->format_date( DateTime->new( year => $tweet_day_regist->year, month => $tweet_day_regist->month, day => 1 ) ),
						DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $tweet_day_regist->year, month => $tweet_day_regist->month ) ),
					);
					my $tracks_month_date;
					if ( $TODAY->year == $tweet_day_regist-> year && $TODAY->month == $tweet_day_regist->month ) {
						$tracks_month_date = "今月";
					} elsif ( $TODAY->year == $tweet_day_regist-> year ) {
						$tracks_month_date = sprintf("%d月", $tweet_day_regist->strftime('%m') );
					} else {
						$tracks_month_date = sprintf("%2d年%d月", $tweet_day_regist->strftime('%y'), $tweet_day_regist->strftime('%m') );
					}
					$tracks_month_message = "これで" . $tracks_month_date . "の走行距離は" . sprintf("%dkm" , $tracks_month->get_column('sum_distance') ) . "だ！";
					$tweet_max -= length($tracks_month_message);
				}
				
				my $tweet_skip_flag = 0;
				my $tweet_day = sprintf("%d/%d", $tweet_day_regist->strftime('%m'), $tweet_day_regist->strftime('%d') );
				my $tweet_day_dup = $tweet_day_regist - DateTime->now( time_zone=>'local' );
				if ( $TODAY->year == $tweet_day_regist->year && $TODAY->month == $tweet_day_regist->month && $TODAY->day == $tweet_day_regist->day ) {
					$tweet_day = "今日";
				} elsif ( $YESTARDAY->year == $tweet_day_regist->year && $YESTARDAY->month == $tweet_day_regist->month && $YESTARDAY->day == $tweet_day_regist->day ) {
					$tweet_day = "昨日";
				}
				$tweet_message = $tweet_message . $tweet_day;
				if ( defined $track{'distance'} && $calc_flag{'distance'} ){
					if ( defined $track{'speed'} ) {
						$tweet_message = $tweet_message . sprintf("は%.1f時間走ったな！平均速度は%.1fkm/hだから、距離は%.1fkmだな！", $track{'time'},$track{'speed'},$track{'distance'});
					} else {
						$tweet_message = $tweet_message . sprintf("は%.1f時間走ったな！距離はおおよそ%.1fkmくらいだろう。", $track{'time'}, $track{'distance'});
					} 
					$tweet_message = $tweet_message . "そして";
				} elsif ( defined $track{'distance'} ) {
					$tweet_message = $tweet_message . sprintf("は%.1fkm走ったな！",$track{'distance'});
					if ( $calc_flag{'time'} && !defined $track{'speed'} ) {
						$tweet_message = $tweet_message . sprintf("走行時間はおおよそ%.1f時間くらいだろう。", $track{'time'});
					} elsif ( $calc_flag{'time'} && defined $track{'speed'} && !$calc_flag{'speed'}) {
						$tweet_message = $tweet_message . sprintf("平均速度は%.1fkm/hだから、走行時間は%.1f時間だな！",$track{'speed'}, $track{'time'});
					} elsif ( !$calc_flag{'time'} && $calc_flag{'speed'}) {
						$tweet_message = $tweet_message . sprintf("走行時間は%.1f時間！平均速度は%.1fkm/hになる。", $track{'time'}, $track{'speed'});
					} elsif ( !$calc_flag{'time'} && defined $track{'speed'} && !$calc_flag{'speed'} ) {
						$tweet_message = $tweet_message . sprintf("走行時間は%.1f時間！平均速度は%.1fkm/h！", $track{'time'}, $track{'speed'});
					}
					$tweet_message = $tweet_message . "そして";
				} elsif ( defined ${'speed'} ) {
					$tweet_message = $tweet_message . sprintf("の平均速度は%.1fkm/hだ！そして", $track{'speed'});
				} else {
					$tweet_message = $tweet_message . "の走行記録";
				}

				if ( defined $track{'speedmax'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、最高速度は%.1fkm/h",$track{'speedmax'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'elevation'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、累積標高は%.1fm",$track{'elevation'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'cadence'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、平均ケイデンスは%drpm",$track{'cadence'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'cadencemax'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、最高ケイデンスは%drpm",$track{'cadencemax'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'power'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、平均出力は%dW",$track{'power'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'powermax'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、最大出力は%dW",$track{'powermax'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'heartrate'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、平均心拍数は%d",$track{'heartrate'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( defined $track{'heartratemax'} ) {
					if (length($tweet_message) < $tweet_max ){
						$tweet_message = $tweet_message . sprintf("、最大心拍数は%d",$track{'heartratemax'} );
					} else {
						$tweet_skip_flag = 1;
					}
				}
				if ( $tweet_skip_flag ) { $tweet_message = $tweet_message . "！以下略"; }
				if ( defined $track{'distance'} && defined $track{'calorie'} ) { 
					$tweet_message = $tweet_message . sprintf("！消費カロリーは%dkcalだぞ！",$track{'calorie'} );
					$tweet_message = $tweet_message . $tracks_month_message;
				} else {
					$tweet_message = $tweet_message . "だ！";
				}
				$twitter->update($tweet_message);
				print $tweet_message . "\n";
			} elsif ( defined $track{'checkrecord_flag'} or defined $track{'date'} or defined $track{'year'} or defined $track{'month'} ) {
				my $firstdate = "1000-01-01";
				my $lastdate  = "9999-12-31";
				if ( defined $track{'date'} ) {
					$firstdate = $track{'date'};
					$lastdate  = $track{'date'};
					my $tweet_day_regist = DateTime::Format::DateParse->parse_datetime($track{'date'});
					if ( $TODAY->year == $tweet_day_regist->year && $TODAY->month == $tweet_day_regist->month && $TODAY->day == $tweet_day_regist->day ) {
						$tweet_message = $tweet_message . "今日";
					} elsif ( $YESTARDAY->year == $tweet_day_regist->year && $YESTARDAY->month == $tweet_day_regist->month && $YESTARDAY->day == $tweet_day_regist->day ) {
						$tweet_message = $tweet_message . "昨日";
					} else {
						$tweet_message = $tweet_message . sprintf("%d/%d", $tweet_day_regist->strftime('%m'), $tweet_day_regist->strftime('%d') );
					}
				} elsif ( defined $track{'year'} && defined $track{'month'} ) {
					$firstdate = DateTime::Format::MySQL->format_date( DateTime->new( year => $track{'year'}, month => $track{'month'}, day => 1 ) );
					$lastdate  = DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $track{'year'}, month => $track{'month'} ) );

					if ( $TODAY->year == $track{'year'} && $TODAY->month == $track{'month'} ) {
						$tweet_message = $tweet_message . "今月";
					} elsif ( $TODAY->year == $track{'year'} ) {
						$tweet_message = $tweet_message . $track{'month'} . "月";
					} else {
						$tweet_message = $tweet_message . $track{'year'} . "年" . $track{'month'} . "月";
					}
				} elsif ( defined $track{'year'} ) {
					$firstdate = DateTime::Format::MySQL->format_date( DateTime->new( year => $track{'year'}, month => 1, day => 1 ) );
					$lastdate  = DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $track{'year'}, month => 12 ) );
					if ( $TODAY->year == $track{'year'} ) {
						$tweet_message = $tweet_message . "今年";
					} else {
						$tweet_message = $tweet_message . $track{'year'} . "年";
					}
				} elsif ( defined $track{'month'} ) {
					$firstdate = DateTime::Format::MySQL->format_date( DateTime->new( year => $TODAY->year, month => $track{'month'}, day => 1 ) );
					$lastdate  = DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $TODAY->year, month => $track{'month'} ) );
					if ( $TODAY->year == $track{'month'} ) {
						$tweet_message = $tweet_message . "今月";
					} else {
						$tweet_message = $tweet_message . $track{'month'} . "月";
					}
				} else {
					$tweet_message = $tweet_message . "これまでの全てで";
				}
				
				my $mytracks_count = $trackschema->getTrackscountByTerm(
					$schema->resultset('Jitensyamantrack'),
					$userid,
					$firstdate,
					$lastdate,
				);
				
				if ( $mytracks_count > 0 ){
					my $mytracks = $trackschema->getTracksByTerm(
						$schema->resultset('Jitensyamantrack'),
						$userid,
						$firstdate,
						$lastdate,
					);
					$tweet_message = $tweet_message . "の走行記録だ！" . $mytracks_count . "回走ってるな";
					
					my $max_length = 110;
					if ( $mytracks->get_column('sum_distance') > 0 ) { $tweet_message = $tweet_message . sprintf("、総走行距離は%dkm",$mytracks->get_column('sum_distance') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_distance') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均走行距離は%dkm",$mytracks->get_column('avg_distance') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('sum_time') > 0 ) { $tweet_message = $tweet_message . sprintf("、総走行時間は%d時間",$mytracks->get_column('sum_time') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_time') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均走行時間は%.1f時間",$mytracks->get_column('avg_time') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('sum_elevation') > 0 ) { $tweet_message = $tweet_message . sprintf("、総累計標高は%dm",$mytracks->get_column('sum_elevation') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_elevation') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均累計標高は%dm",$mytracks->get_column('avg_elevation') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_speed') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均速度は%.1fkm/h",$mytracks->get_column('avg_speed') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('max_speedmax') > 0 ) { $tweet_message = $tweet_message . sprintf("、最高速度は%dkm/h",$mytracks->get_column('max_speedmax') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_cadence') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均ケイデンスは%drpm",$mytracks->get_column('avg_cadence') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('max_cadencemax') > 0 ) { $tweet_message = $tweet_message . sprintf("、最高ケイデンスは%drpm",$mytracks->get_column('max_cadencemax') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_power') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均出力は%dW",$mytracks->get_column('avg_power') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('max_powermax') > 0 ) { $tweet_message = $tweet_message . sprintf("、最大出力は%dW",$mytracks->get_column('max_powermax') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_heartrate') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均心拍数は%dbpm",$mytracks->get_column('avg_heartrate') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('max_heartratemax') > 0 ) { $tweet_message = $tweet_message . sprintf("、最大心拍数は%dbpm",$mytracks->get_column('max_heartratemax') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('sum_calorie') > 0 ) { $tweet_message = $tweet_message . sprintf("、総消費カロリーは%dkcal",$mytracks->get_column('sum_calorie') ); }
					$tweet_message = &check_tweet_long( $tweet_message, $max_length, $username );
					if ( $mytracks->get_column('avg_calorie') > 0 ) { $tweet_message = $tweet_message . sprintf("、平均消費カロリーは%dkcal",$mytracks->get_column('avg_calorie') ); }
					$tweet_message = $tweet_message . "だ！";
				} else {
					$tweet_message = $tweet_message . "、走ったって聞いてないぞ！";
				}
				$twitter->update($tweet_message);
				print $tweet_message . "\n";
			} else {
				$tweet_message = $tweet_message . $tweet_messages->{'reply'}[int( rand(@{$tweet_messages->{'reply'}}) )];
				$twitter->update($tweet_message);
				print $tweet_message . "\n";
			}
		}
	}
	$page++;
}

if ( $TODAY->day == 1 && $TODAY->hour == 12 && $TODAY->minute < 3 ) {
	my $firstday_of_lastmonth = DateTime::Format::MySQL->format_date( DateTime->new( year => $YESTARDAY->year, month => $YESTARDAY->month, day => 1 ) );
	my $lastday_of_lastmonth = DateTime::Format::MySQL->format_date( DateTime->last_day_of_month( year => $YESTARDAY->year, month => $YESTARDAY->month ) );

	my $monthusers = $trackschema->getUsersByMonth(
		$schema->resultset('Jitensyamantrack'),
		$firstday_of_lastmonth,
		$lastday_of_lastmonth,
	);
	while (my $userid_month = $monthusers->next) {

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
		$twitter->update($tweet_message_of_lastmonth);
		print $tweet_message_of_lastmonth . "\n";
	}
}

if ( $TODAY->minute < 3 ) {
	my $tweet_alone = $tweet_messages->{'tweet'}[int( rand(@{$tweet_messages->{'tweet'}}) )];
	$twitter->update($tweet_alone);
	print $tweet_alone . "\n";
}


sub make_date1(){
	my ($year, $month, $day) = @_;
	my $date;
	if ( $year == 0 && $month == 0 ){
		$date = DateTime->new( time_zone=>'local', year=>$TODAY->year, month=>$TODAY->month, day=>$day, hour=>0, minute=>0, second=>0 );
		if ($TODAY < $date ) { $date->subtract( months => 1 ); }
	} elsif ( $year == 0 ) {
		$date = DateTime->new( time_zone=>'local', year=>$TODAY->year, month=>$month, day=>$day, hour=>0, minute=>0, second=>0 );
		if ($TODAY < $date ) { $date->subtract( years => 1 ); }
	} else {
		$date = DateTime->new( time_zone=>'local', year=>$year, month=>$month, day=>$day, hour=>0, minute=>0, second=>0 );
	}
	return DateTime::Format::MySQL->format_date( $date ),
}
sub make_date2(){
	my ($when) = @_;
	my $date = DateTime->now( time_zone=>'local' );
	if ( $when =~ /(今日|きょう|today)/i ) {
	} elsif ( $when =~ /(おととい|一昨日)/i ) {
		$date->subtract( days => 2 );
	} elsif ( $when =~ /(昨日|きのう|yestarday)/i ) {
		$date->subtract( days => 1 );
	}
	return DateTime::Format::MySQL->format_date( $date ),
}
sub make_distance(){
	my ($value, $unit) = @_;
	my $distance = $value;
	if ( $unit =~ /(km|キロ|キロメートル)/i ) {
	} elsif ( $unit =~ /(mile|miles|マイル)/i ) {
		$distance = $value * 1.609344;
	} elsif ( $unit =~ /(m|メートル)/i ) {
		$distance = $value / 1000;
	}
#	print "value = " . $value . ", unit = " . $unit . ", distance = " . $distance . "\n";
	return $distance;
}

sub make_time1(){
	my ($hour, $min, $sec) = @_;
	$min = 0 if (!defined $min);
	$sec = 0 if (!defined $sec);
	my $time = $hour + $min / 60 + $sec / 3600;
=comment
	my $time = $hour . ":" . sprintf("%02d",$min) . ":" . sprintf("%02d",$sec);
	my $time = DateTime::Duration->new( time_zone=>'local' ,
		hours => $hour,
		minutes => $min,
		seconds => $sec,
	);
=cut
#	print "time = " . $time . "\n";
	return $time;
}

sub make_time2(){
	my ($value, $unit) = @_;
	my $time = $value;
	if ( $unit =~ /(時間|h|hour)/i ) {
#		$time = DateTime::Duration->new( hours => $value );
#		$time = $value . ":00:00";
	} elsif ( $unit =~ /(分|min)/i ) {
#		$time = DateTime::Duration->new( minutes => $value );
#		$time = "0:" . $value . ":00";
		$time = $time / 60
	}
#	print "value = " . $value . ", unit = " . $unit . ", time = " . $time . "\n";
	return $time;
}
sub make_elevation(){
	my ($value, $unit) = @_;
	my $elevation = $value;
	if ( $unit =~ /feet/i ) {
		$elevation = $value * 0.3048;
	}
#	print "value = " . $value . ", unit = " . $unit . ", elevation = " . $elevation . "\n";
	return $elevation;
}
sub make_speed(){
	my ($value, $unit1, $unit2) = @_;
	my $speed = $value;
	if ( $unit1 =~ /(km|キロ|キロメートル)/i ) {
	} elsif ( $unit1 =~ /(mile|miles|マイル)/i ) {
		$speed = $value * 1.609344;
	} elsif ( $unit1 =~ /(m|メートル)/i ) {
		$speed = $value / 1000;
	}
#	print "value = " . $value . ", unit1 = " . $unit1 . ", unit2 = " . $unit2. ", speed = " . $speed . "\n";
	return $speed;
}
sub make_cadence(){
	my ($value, $unit) = @_;
	my $cadence = $value;
#	print "value = " . $value . ", unit = " . $unit . ", cadence = " . $cadence . "\n";
	return $cadence;
}
sub make_heartrate(){
	my ($value, $unit) = @_;
	my $heartrate = $value;
#	print "value = " . $value . ", unit = " . $unit . ", heartrate = " . $heartrate . "\n";
	return $heartrate;
}
sub make_power(){
	my ($value, $unit) = @_;
	my $power = $value;
#	print "value = " . $value . ", unit = " . $unit . ", heartrate = " . $power . "\n";
	return $power;
}
sub make_calorie(){
	my ($value, $unit) = @_;
	my $calorie = $value;
#	print "value = " . $value . ", unit = " . $unit . ", calorie = " . $calorie . "\n";
	return $calorie;
}

sub calc_speed(){
	my ($distance, $time) = @_;
	my $speed = $distance / $time;
	return $speed;
}
sub calc_time(){
	my ($distance, $speed) = @_;
	my $time = $distance / $speed;
	return $time;
}
sub calc_distance(){
	my ($time, $speed) = @_;
	my $distance = $speed * $time;
	return $distance;
}
sub calc_calorie(){
	my ($time, $speed) = @_;
	my $mets = 4;
	my $weight = 50;
	if ( $speed >= 32 ) { $mets = 16; }
	elsif ( $speed >= 25.7 ) { $mets = 12; }
	elsif ( $speed >= 22.5 ) { $mets = 10; }
	elsif ( $speed >= 19.3 ) { $mets = 8; }
	elsif ( $speed >= 16 ) { $mets = 6; }
	my $calorie = $mets * $weight * $time * 1.05;
	return $calorie;
}

sub check_tweet_long(){
	my ( $tweet_message, $max_length, $username ) = @_;
	if (length($tweet_message) >= $max_length ){
		$twitter->update( $tweet_message . "だ！続くぞ！");
		print $tweet_message . "だ！続くぞ！" . "\n";
		$tweet_message = "@" . $username . " ！続きだ";
	}
	return $tweet_message;
}

