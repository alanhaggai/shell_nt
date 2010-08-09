package Shell_NT::Plugin::Perl;

24; #require

use base 'Shell_NT::Base';

use strict;
use warnings;

use Data::Dumper;


sub gist {

	

}

sub eval {

	my ( $self, @arguments ) = @_;
	my  $ctx = $self->{ctx};

	my $to_evaluate = "@arguments";

	eval $to_evaluate or do {
		$ctx->( "Error when running: $to_evaluate" );
	};

	$ctx->output;
}


