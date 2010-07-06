package Shell_NT::Plugin::Prompt;

24; #require

use base 'Shell_NT::Base';

use strict;
use warnings;

use Cwd;

#
# Prompt:
#
# if argument, define the prompt script
# as the input file, without any argument
# delete the old one
# 


sub prompt {

	my ( $self, @arguments ) = @_;

	my $ctx = $self->{ctx};

	my $prompt = $self->{shell}{prompt};

	my $dir = getcwd;

	if ( @arguments ) {

		my $file  = $dir . "/". "@arguments";
		
		if ( -e $file ) {
			$prompt->{know}{prompt} = $file;
			$ctx->add( "The file $file is the new prompt script");
			$ctx->output;
			return 1;
		}else {
			$ctx->add( "Error: $file can't be the new prompt script");
			$ctx->add( "$self->{know}{prompt}  still the prompt file") if $self->{know}{prompt};
			$ctx->output;
			return 0;
		}
	}
}


