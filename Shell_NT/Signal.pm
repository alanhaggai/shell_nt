package Shell_NT::Signal;

24; #require

use strict;
use warnings;
use Data::Dumper;

use Shell_NT::Know;

#
# The ideia is to use this to build the 
# signal captchrs
#

sub new {

	my ($class) = @_;

	#know/data/config
	(my $know_dir = $class) =~ s/::/\//g;
	$know_dir =~ s/Shell_NT\///;

	my $data = Shell_NT::Know->new( $know_dir );

	my $self = {
		stamp => time(),
		context => undef,
		data => $data,
		know => $data->{know},
	};

	bless $self, $class;

	# define the catcers based on bla bla bla
	$SIG{INT} = $self->_get_int();

	return $self;

}

sub _get_int {

	my $self = shift;
	
	return sub { print "Zap!\n"; };
	
}

sub alarm {

	my ( $self, $command, $pid ) = @_;

	print "foo\n";

	$SIG{ALRM} = sub {

		kill 9 , $pid;

		print "Killed $command, with pid $pid after 5 seconds in parse mode, maybe you should try noparse $command to run it\n";

	}

}

__END__

#
# Context temporary
#

sub context {

	my ($self, $context) = @_;
	
	$self->{shell} = $self;
	
	my $ctx = {
		history => $self->{history},
		stack => $self->{stack},
		out_stack => $self->{out_stack},
		
	}

}
