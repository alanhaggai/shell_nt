package Shell_NT::Plugin::History;

24; #require

use base 'Shell_NT::Base';

use strict;
use warnings;

#
# history - print the history
#

sub history {

	my ($self, @arguments) = @_;

	my $ctx = $self->{ctx};

	my $history = $self->{shell}{history};

	for ( $history->all() ){
		$ctx->add( $_->[-1] );
	}

	$ctx->output();

	1;

}

