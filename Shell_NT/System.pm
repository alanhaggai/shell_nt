package Shell_NT::System;

use base 'Shell_NT::Base';

24; #require

use IPC::Open3;

#
# It is supposed to be a true fork to enable
# a second plane
#

sub system_interactive {

    my ($self, $command, @args) = @_;

    for $path (split(/:/ , $ENV{PATH}) ) {
        if ( -x "$path/$command" ){
            print "run: $path/$command @args\n";
            system("$path/$command @args");
            return 0;
        }
    }

    return 1;
}

# 
# Is possible to attach to console 
# in case of interative thing, like vim?
#
# Also, fork and run in bg?
# Yes, fork and run in bg

sub system_parsed {

    my ($self, $command, @args) = @_;

	$ctx = $self->{ctx};

	my ( $read, $write, $error);

	my $pid = open3( $write, $read, $error, "$command @args");
	
	waitpid $pid, 0;

	while( <$read> ){
	
		$ctx->add ( $_ );
	
	}

	$ctx->output();

	return 0;

}

sub system_fallback {

	my ($self, $command, @args) = @_;



	
}
