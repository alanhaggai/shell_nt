package Shell_NT::System;

use base 'Shell_NT::Base';

use warnings;
use strict;

use Data::Dumper;

use IPC::Open3; 

24; #require

#
# It is supposed to be a true fork to enable
# a second plane
#

sub system_interactive {

    my ($self, $command, @args) = @_;

    for my $path (split(/:/ , $ENV{PATH}) ) {
        if ( -x "$path/$command" ){
            print "run: $path/$command @args\n";
            my $status = system("$path/$command @args");
            return $status;
        }
    }

    return 0;
}

# 
# Is possible to attach to console 
# in case of interative thing, like vim?
#
# Also, fork and run in bg?
# Yes, fork and run in bg

sub system_parsed {

    my ($self, $command, @args) = @_;

	my $ctx = $self->{ctx};

	my ( $read, $write, $error );

	my $pid = open3( $write, $read, $error, "$command @args");
	
	waitpid $pid, 0;

	my $status = $?;
	print "$command exited with non zero as $status\n"; # if verbose bla

	while( <$read> ){
	
		$ctx->add ( $_ );
	
	}

	$ctx->output( $status );

	return $status;

}

# Take from a hash the list of commands to DO NOT
# parse the output
# 

sub system_fallback {

	my ($self, $command, @args) = @_;

	if ( $self->to_be_parsed($command) ) {
		return $self->system_parsed($command, @args);
	}else {
		return $self->system_interactive($command,@args);
	}
}


sub to_be_parsed {

	my ($self , $command ) = @_;
	
	if (exists $self->{know}{parsed}{$command}) {
		return 0 if $self->{know}{parsed}{$command} == 0;
	}
	return 1;
}
