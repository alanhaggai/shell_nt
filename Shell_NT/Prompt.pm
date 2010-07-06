package Shell_NT::Prompt;

use base 'Shell_NT::Base';

#
# This package is the Prompt generator
# The function "get_prompt" simply
# returns a string with the prompt
#

24; #require

use strict;
use warnings;

use Data::Dumper;

#
# TODO have context inside here also
#
# Should define a namespace for itA
#

sub prompt {

	my ( $self ) = @_;

#	print Dumper $self;return;

	my $prompt_script = $self->{know}{prompt};

	my $prompt = $self->basic();

	return $prompt. "-->";
	
}

#
# Hardcoded for myself only 
#

# eee to many forks

sub basic {

	my $git = qx#git branch 2>/dev/null#;
	my $dir = qx#pwd#;
	my $host = qx#hostname#;

	chomp $git;
	chomp $dir;
	chomp $host;

	return "[: $git ] \@$host on $dir\n"; 



}
