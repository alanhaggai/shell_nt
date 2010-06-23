package Shell_NT::Plugin::Core;

24; #require

# this modules has the core user functions commands
# the internal core is under Shell_NT::*

use base 'Shell_NT::Base';

use strict;
use warnings;

use Data::Dumper;

# base?
sub meta {

	my ($self ) = @_;

	# Just Dump the first level of 
	# shell object
	
	$Data::Dumper::Maxdepth = 1;
	
	print "\nShell_NT Meta Dump:\n";
	print Dumper $self->{shell};
}

# built-in not to much
# stack of directories 
# for now the history works

sub cd {

	my ($self, @arguments) = @_;

	if (@arguments) {
		chdir "@arguments";
	} else {
		chdir $ENV{HOME};
	}

}

# cry for exiting!

sub exit {

	# messages as functions
	print "Oh, goodbye cruel World!\n";
	exit 0;

}


sub set {

    my ($self, @args) = @_;

    push @{ $self->{ctx}{stack} }, "@args";

	# verbs
	print "Added @args to ", scalar @{ $self->{ctx}{stack} }, " position at main stack\n";

}

# Should be in command line (or related)
# or define core as interface to core functions
# no and yes can be more abstract TODO

sub noparse {

	my ($self, $command ) = @_;

	$self->{shell}{exec}{know}{parsed}{$command} = 0;

	return 1 if $self->{shell}{exec}{know}{parsed}{$command} == 0;

}

sub parse {

	my ($self, $command ) = @_;

	$self->{shell}{exec}{know}{parsed}{$command} = 1;

	return 1 if $self->{shell}{exec}{know}{parsed}{$command} == 1;

}

sub enviroment {

	# function answer list
	# answer list can be paged (externally)

	print "This is the enviroment variables\n";
    print map { "$_  =  $ENV{$_}\n"  }  keys %ENV;


}

sub show_stack {

    my ($self, @args) = @_;

    my $i = 0;

    print map { $i++ ; ">$i: $_\n" } @{ $self->{ctx}{stack} } ;

}

sub pid {

	# function answer is ... we are asking
	print "My pid is $$\n";

}
