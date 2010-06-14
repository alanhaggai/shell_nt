package Shell_NT::Plugin::Test;

24; #require

use base 'Shell_NT::Plugin::Base';

use strict;
use warnings;

use Data::Dumper;

sub test_for_parameters {

	print Dumper @_;

}

sub this_is_just_for_reload_test {

	print "Oh god!\n";

}

