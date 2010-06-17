package Shell_NT::Plugin::Test;

24; #require

use base 'Shell_NT::Base';

use strict;
use warnings;

use Data::Dumper;

sub test_for_parameters {

	print Dumper @_;

}

sub this_is_just_for_reload_test {

	print "Oh god!\n";

}

sub meta3 {

	my ($self ) = @_;
	
	$self->{shell}{exp} ++;

	# Just Dump the first level of 
	# shell object
	
	$Data::Dumper::Maxdepth = 1;
	
	print "\nShell_NT Meta Dump:\n";
	print Dumper $self->{shell};
	
	$self->{shell}{exp} ++;



}

