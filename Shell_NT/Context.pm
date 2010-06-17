package Shell_NT::Context;

24; # require

#
# Basic input/output for plugins
# 
# The ideia is simple, make available 
# globally a history of output of commands
# that can be parsed and used with a set of 
# commands
#


# free object

sub new {

	my ($class) = @_;
	
	my $self = {

		stack => [],
		user_stack => [],
		foo => [] ,

	};

	bless $self, $class;

	return $self;

}

sub add {

	my ($self, $first, @args ) = @_;

	
	# this is a scalar?
	if ( ! ref $first ) {
		chomp $first;
		push @{ $self->{stack} } , [ time() , $first ];  

	}else {
		
		push @{ $self->{stack} }, [ time(), "Not\ supported\ Push!" ];

	}

}

# Add my own \n

sub output {

	my ($self ) = @_;
	
	for my $line ( @{ $self->{stack} } ) {
		
		# add the output as variables
		print map { "0,0[$_] " }  split (/ /, $line->[1] );
		print "\n";

	}

	#clean-up the stack
}

sub interpolate {

	my $cmdline = $_[1];

	if ( $cmdline =~ m/\$(\d)\,(\d)/ ) {
		print "found! $1 and $2\n";
	}

	return $cmdline;


}

