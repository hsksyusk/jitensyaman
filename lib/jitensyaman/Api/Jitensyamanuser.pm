package jitensyaman::Api::Jitensyamanuser;

use strict;
use warnings;
use jitensyaman::Schema;

sub new {
	return bless {}, shift;
}

sub getUserid {
	my ($self, $rs, $id, $screen_name) = @_;
	my $user = $rs->search({
		twitter_user_id => $id,
	});
	my $userid;
	if ( $user->count ){
		my $temp_user = $user->next;
		$temp_user->update({ twitter_user => $screen_name, });
		$userid = $temp_user->id_field;
	} else {
		my $row = $rs->create({
			twitter_user_id => $id,
			twitter_user => $screen_name,
		});
		$userid = $row->id;
	}
	return $userid;
}

sub getTwitteruserById {
	my ($self, $rs, $id_field ) = @_;
	return $rs->find($id_field)->twitter_user;
}
1;
