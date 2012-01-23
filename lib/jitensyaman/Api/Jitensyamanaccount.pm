package jitensyaman::Api::Jitensyamanaccount;

use strict;
use warnings;
use jitensyaman::Schema;

sub new {
	return bless {}, shift;
}

sub getWeightById {
	my ($self, $rs, $id_field) = @_;
	return $rs->find($id_field)->weight;
}

sub getRecordById {
	my ($self, $rs, $id_field, $date ) = @_;
	return $rs->find_or_create({
		id_field => $id_field,
		continuerecorddate => "1000-01-01",
	});
}
sub updateContinueRecordById {
	my ($self, $rs, $id_field, $continuerecord, $continuerecorddate ) = @_;
	$rs->find($id_field)->update({ continuerecord => $continuerecord, continuerecorddate => $continuerecorddate });
}

sub updateWeightById {
	my ($self, $rs, $id_field, $weight ) = @_;
	$rs->find($id_field)->update({ weight => $weight });
}

1;
