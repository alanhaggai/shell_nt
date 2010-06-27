package Shell_NT::Plugin::Meta;

24; #require

use base 'Shell_NT::Base';

# Just about meta information about this shell
# Also just meta internal

use strict;
use warnings;

use Data::Dumper;

# Meta: 
# Show the shell object, in depth 
# and if passed as paramter a specefic key

sub meta {

	my ($self, $depth, $key ) = @_;
	my $ctx = $self->{ctx};

	$Data::Dumper::Maxdepth = $depth || 1;
	
	for my $line (  split (/\n/ , 
					Dumper $key ? $self->{shell}{$key}
								: $self->{shell} )    ){
		$ctx->add( $line );
	}
	$ctx->add( "Shell_NT Meta Dump above");
	$ctx->add( "Displaying the $key\n" ) if $key;
	
	$ctx->output;
	1;
}
