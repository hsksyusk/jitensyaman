package jitensyaman::Api::Jitensyamantrack;

use strict;
use warnings;
use jitensyaman::Schema;
use Data::Dumper;
use DateTime;
use DateTime::Format::MySQL;
use DateTime::Format::DateParse;

sub new {
	return bless {}, shift;
}

sub create {
	my ($self, $rs, $id_field, $date, $distance, $time, $elevation, $speed, $speedmax, $cadence, $cadencemax, $power, $powermax, $heartrate, $heartratemax, $calorie, $tweet ) = @_;
	$rs->create({
		id_field     => $id_field,
		date         => $date,
		create_date  => \'NOW()',
		update_date  => \'NOW()',
		distance     => $distance,
		time         => $time,
		elevation    => $elevation,
		speed        => $speed,
		speedmax     => $speedmax,
		cadence      => $cadence,
		cadencemax   => $cadencemax,
		power        => $power,
		powermax     => $powermax,
		heartrate    => $heartrate,
		heartratemax => $heartratemax,
		calorie      => $calorie,
		tweet        => $tweet,
	});
}

sub getTracksByTerm {
	my ($self, $rs, $id_field, $firstdate, $lastdate ) = @_;
	return $rs->search(
		{
			'id_field' => $id_field,
			'date' => { 'BETWEEN' => [$firstdate,$lastdate] },
		},
		{
			select => [{ sum => 'distance' },{ AVG => 'distance' },{ sum => 'time' },{ AVG => 'time' }, { sum => 'elevation' },{ AVG => 'elevation' }, { AVG => 'speed' }, { MAX => 'speedmax' }, { AVG => 'cadence' }, { MAX => 'cadencemax' }, { AVG => 'power'}, { MAX => 'powermax' }, { AVG => 'heartrate' }, { MAX => 'heartratemax' }, { sum => 'calorie' }, { AVG => 'calorie' } ],
			as => ['sum_distance','avg_distance','sum_time','avg_time','sum_elevation','avg_elevation', 'avg_speed' , 'max_speedmax' , 'avg_cadence' , 'max_cadencemax' , 'avg_power', 'max_powermax' , 'avg_heartrate' , 'max_heartratemax' , 'sum_calorie', 'avg_calorie' ],
			group_by => ['id_field'],
		}
	)->next;

}

sub getTrackscountByTerm {
	my ($self, $rs, $id_field, $firstdate, $lastdate ) = @_;
	return $rs->search(
		{
			'id_field' => $id_field,
			'date' => { 'BETWEEN' => [$firstdate,$lastdate] },
		},
		{ group_by => ['date'] }
	)->count;
}
sub getTrackscountByIdfield {
	my ($self, $rs, $id_field ) = @_;
	return $rs->search(
		{ 'id_field' => $id_field,},
		{ group_by => ['date'] }
	)->count;
}
sub getUsersByMonth {
	my ($self, $rs, $firstdate, $lastdate ) = @_;
	return $rs->search(
		{
			'date' => { 'BETWEEN' => [$firstdate,$lastdate] },
		},
		{
			select => 'id_field',
			group_by => ['id_field'],
		}
	);
}

sub deleteLastUpdateByUser {
	my ($self, $rs, $id_field ) = @_;
	my $lastupdate = $rs->search(
		{'id_field' => $id_field} ,
		{ order_by => { -desc => 'id' } },
	)->next;
	my $lastupdate_date = $lastupdate->date;
	$lastupdate->delete;
	return $lastupdate_date;
}
sub getMaxTracksByIdfield {
	my ($self, $rs, $id_field) = @_;

	my %maxtracks;
	my $max_distance = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','distance'], 
			order_by => [{ -desc => 'distance' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'distance'} = { 'date' => $max_distance->date, 'value' => $max_distance->distance } if ( $max_distance->distance > 0 );
	my $max_time = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','time'], 
			order_by => [{ -desc => 'time' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'time'} = { 'date' => $max_time->date, 'value' => $max_time->time } if ( $max_time->time > 0 );
	my $max_speed = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','speed'], 
			order_by => [{ -desc => 'speed' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'speed'} = { "date" => $max_speed->date, "value" => $max_speed->speed, } if ( $max_speed->speed > 0 ) ;
	my $max_speedmax = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','speedmax'], 
			order_by => [{ -desc => 'speedmax' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'speedmax'} = { "date" => $max_speedmax->date, "value" => $max_speedmax->speedmax, } if ( $max_speedmax->speedmax > 0 ) ;
	my $max_elevation = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','elevation'], 
			order_by => [{ -desc => 'elevation' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'elevation'} = { "date" => $max_elevation->date, "value" => $max_elevation->elevation, } if ( $max_elevation->elevation > 0 ) ;
	my $max_cadence = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','cadence'], 
			order_by => [{ -desc => 'cadence' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'cadence'} = { "date" => $max_cadence->date, "value" => $max_cadence->cadence, } if ( $max_cadence->cadence > 0 ) ;
	my $max_cadencemax = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','cadencemax'], 
			order_by => [{ -desc => 'cadencemax' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'cadencemax'} = { "date" => $max_cadencemax->date, "value" => $max_cadencemax->cadencemax, } if ( $max_cadencemax->cadencemax > 0 ) ;
	my $max_power = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','power'], 
			order_by => [{ -desc => 'power' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'power'} = { "date" => $max_power->date, "value" => $max_power->power, } if ( $max_power->power > 0 ) ;
	my $max_powermax = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','powermax'], 
			order_by => [{ -desc => 'powermax' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'powermax'} = { "date" => $max_powermax->date, "value" => $max_powermax->powermax, } if ( $max_powermax->powermax > 0 ) ;
	my $max_calorie = $rs->search(
		{ 'id_field' => $id_field, },
		{ 
			select => ['date','calorie'], 
			order_by => [{ -desc => 'calorie' },{ -asc => 'date' }],
		},
	)->next;
	$maxtracks{'calorie'} = { "date" => $max_calorie->date, "value" => $max_calorie->calorie, } if ( $max_calorie->calorie > 0 ) ;

	return %maxtracks;
}
sub getContinueDays {
	my ($self, $rs, $id_field, $continuedate ) = @_;

	my $backwarddate = DateTime::Format::DateParse->parse_datetime($continuedate);
	$backwarddate->subtract( days => 1 );
	my $forwarddate = DateTime::Format::DateParse->parse_datetime($continuedate);
	$forwarddate->add( days => 1 );

	my $backward = $rs->search(
		{
			'id_field' => $id_field,
			'date' => { 'BETWEEN' => ["1000-01-01",DateTime::Format::MySQL->format_date($backwarddate)] },
		},
		{
			select => 'date',
			order_by => { -desc => 'date' },
			group_by => ['date'],
		}
	);
	my $forward = $rs->search(
		{
			'id_field' => $id_field,
			'date' => { 'BETWEEN' => [DateTime::Format::MySQL->format_date($forwarddate),"9999-12-31"] },
		},
		{
			select => 'date',
			order_by => { -asc => 'date' },
			group_by => ['date'],
		}
	);

	my $continuedate_date = DateTime::Format::DateParse->parse_datetime($continuedate);
	my $backward_days = 0;
	my $backward_date = $continuedate;
	if ( $backward->count > 0){
		while (my $backward_track = $backward->next) {
			my $temp_date = DateTime::Format::DateParse->parse_datetime( $backward_track->date );
			my $temp_dur = $continuedate_date->delta_days($temp_date);
			last if ( $temp_dur->in_units('days') != 1 );
			$continuedate_date = $temp_date;
			$backward_days++;
			$backward_date = $backward_track->date;
		}
	}

	$continuedate_date = DateTime::Format::DateParse->parse_datetime($continuedate);
	my $forward_days = 0;
	my $forward_date = $continuedate;
	if ( $forward->count > 0){
		while (my $forward_track = $forward->next) {
			my $temp_date = DateTime::Format::DateParse->parse_datetime( $forward_track->date );
			my $temp_dur = $continuedate_date->delta_days($temp_date);
			last if ( $temp_dur->in_units('days') != 1 );
			$continuedate_date = $temp_date;
			$forward_days++;
			$forward_date = $forward_track->date;
		}
	}

	my %return_hash = ( 
		"backward_days" => $backward_days,
		"backward_date" => $backward_date,
		"forward_days" => $forward_days,
		"forward_date" => $forward_date,
		"continue_days" => $backward_days + $forward_days + 1,
	);
	return %return_hash;

}


1;