package Shell_NT;

use strict;
use warnings;

24; #require

use base 'Shell_NT::Base';
use Shell_NT::System;
use Shell_NT::History;
use Shell_NT::Context;
use Shell_NT::CommandLineParse;
use Shell_NT::Know;
use Shell_NT::Perl;
use Shell_NT::Prompt;
use Shell_NT::Signal;

use Cwd;
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
	
	# Some hardcoded defaults for now
	# know is the the file that knows 
	# what shell should know :)
	Shell_NT::Know->define_root("$ENV{HOME}/.shell_nt/");
	
	my $self = $class->SUPER::new();
	
	$self->{refdir} = cwd;
	$self->{mycmdline} = "$0 @ARGV";
	
	# History is mandatory to this shell work
	$self->{history} = Shell_NT::History->new();
	
	# To run commands (...)
	# Shell_NT::System acks like a plugin
	# but pass the command to a method
	$self->{exec} = Shell_NT::System->new();
	
	# now, create the terminal
	$self->{terminal} = Term::ReadLine->new('Shell_NT');
	# add the old history to terminal (for use with up key)
	$self->{terminal}->addhistory($_) for ( $self->{history}->all_commands() );
	
	# Add the context
	$self->{ctx} = Shell_NT::Context->new();
	
	# The Perl thing
	$self->{perl} = Shell_NT::Perl->new();
	
	# The command prompt
	$self->{prompt} = Shell_NT::Prompt->new();
	
	# Signal handlers
	$self->{signal} = Shell_NT::Signal->new();
	
	return $self;
	
}

sub console {
	
	my ($self) = @_;

    my $prompt = $self->{prompt};
	my $terminal = $self->{terminal};
   
	my $OUT = $terminal->OUT || \*STDOUT;

	# some flag to end the processing?
    while ( 1 ) {
			$prompt->show();
			my $cmdline = $terminal->readline( ">" );
			$cmdline = $self->{ctx}->interpolate( $cmdline );
			my ( $type, $status ) = $self->_run( $cmdline );
			$self->{history}->push( $type, $status, $cmdline );
    }
}

# it always take from history, the last command
# since the history is per process, this is not a problem
# also we have time stamp to save the history
# Also the cmdline is history should be already interpolated with stack

sub _run {

	my ( $self, $cmdline ) = @_;
	
	warn "$cmdline\n\n" if $ENV{SHELL_NT_DEBUG};

	my ($command , @arguments ) = parse_cmdline( $cmdline );
	
	#
	# run commands in iterative way!
	#
	# if the we have the plugin with the a sub with 
	# the name of command ok , run it
	#
	# otherwise call system
	# 
	 
	my @plugins = $self->plugins();
    print "plugins: @plugins\n" if $ENV{SHELL_NT_DEBUG};

	my $status;
	for my $plugin ( @plugins) {
		next if ! $plugin->can( $command );

		$plugin->attach( $self );
			eval {
				$status = $plugin->$command( @arguments );
			} or do {
				print "Error running $command with @arguments\nand $@\n";
				$status = 0;
			};
		$plugin->detach();
		$self->{status} = [ "P", $status, $cmdline ];
		return "P", $status;
	
	}

	$self->{exec}->attach( $self );
		eval {
			$status = $self->{exec}->system_fallback( $command, @arguments );
		};
	$self->{exec}->detach();

	$self->{status} = [ "S", $status, $cmdline ];
	return "S", $status;

}

sub child {

	my ($self, $child) = @_;
	
	push @{ $self->{childs} } , $child;

}

sub ripchild {

	my ($self, $child) = @_;
	
	$self->{childs} = [ grep { !/$child/ } @{ $self->{childs}} ] ;

}
