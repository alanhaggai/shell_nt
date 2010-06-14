package Shell_NT::Plugin::Base;

# Luke, I'm your father

24; #require

use strict;
use warnings;

# new is necessary!

sub new {

	my ($class) = @_;

	return bless { } , $class;

}

sub context {

	my ($self, $shell) = @_;

	$self->{ctx} = $shell;

}

# end base for all
