package jitensyaman::Api::Jitensyamanparam;

use strict;
use warnings;
use jitensyaman::Schema;

sub new {
	return bless {}, shift;
}

sub getSinceid {
	my ($self, $rs) = @_;
	return $rs->find(1)->sinceid;
}

sub updateSinceid {
	my ($self, $rs, $sinceid) = @_;
	$rs->find(1)->update({ sinceid => $sinceid });
}

1;
