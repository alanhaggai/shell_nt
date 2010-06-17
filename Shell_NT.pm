package Shell_NT;

use strict;
use warnings;

24; #require

use base 'Shell_NT::Base';
use Shell_NT::System;
use Shell_NT::History;
use Shell_NT::Context;

use Data::Dumper;
use Term::ReadLine;
use Class::Inspector;  #TODO

#use Module::Pluggable require => 1;
use Module::Pluggable instantiate => 'new';


# Create a self object for modules
# It contains the actual context
# main stack of data
# main stack of processed data
# version
# other things
#
# The both stacks contains simple data, 
# in case of a scalar, can have a array where
# the first element is the name of this thing
#
# history keeps the commands history, in this form
# 
# [ epoch , $cmdline] 
#

sub new {

    my ($class) = @_;

    my $self = $class->SUPER::new();

	# History is mandatory to this shell work
	$self->{history} = Shell_NT::History->new();

	# now, create the terminal
	$self->{terminal} = Term::ReadLine->new('Shell_NT');
	# add the old history to terminal (for use with up key)
	$self->{terminal}->addhistory($_) for ( $self->{history}->all() );

	# Add the context
	$self->{ctx} = Shell_NT::Context->new();

    return $self;

}

sub console {
	
	my ($self) = @_;

    my $prompt = "#--> ";

	my $terminal = $self->{terminal};
   
	# ?
	my $OUT = $terminal->OUT || \*STDOUT;

    while ( defined (my $cmdline = $terminal->readline( $prompt ) ) ) {
			$cmdline = $self->{ctx}->interpolate( $cmdline );
			$self->{history}->push( $cmdline );
			$self->_run;
    }
}

# it always take from history, the last command
# since the history is per process, this is not a problem
# also we have time stamp to save the history
# Also the cmdline is history should be already interpolated with stack

sub _run {

	my ($self) = @_;
	
	my $cmdline =  $self->{history}->last();

	warn "$cmdline\n\n";

	my ($command , @arguments ) = $self->parse_cmdline( $cmdline );
	
	#
	# run commands in iterative way!
	#
	# if the we have the plugin with the a sub with 
	# the name of command ok , run it
	#
	# otherwise call system
	# 
	 
	my @plugins = $self->plugins();
	
	for my $plugin ( @plugins) {
		next if ! $plugin->can( $command );

		$plugin->attach( $self );
			eval {
				$plugin->$command( @arguments );
			} or do {
				print "Error running $command with @arguments\nand $@\n";
			};
		$plugin->detach();
		return;
	
	}

    print "I don't know what is [$command] @arguments\n$@\n" if 
        Shell_NT::System->system_fallback( $command, @arguments );

}

# should be a module or plugin
# parserec?

sub parse_cmdline {

	my ($self, $cmdline ) = @_;

	return undef if ! $cmdline;
	
	$cmdline =~ m/
		(\w+)
		\s?
		(.*)
	/x;
	
	my $cmd = $1;

	my @args = split(/ /, $2 ) if $2;

	return $cmd, @args;
}


