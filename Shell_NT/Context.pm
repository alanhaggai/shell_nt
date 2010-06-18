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
		parsed => [] ,

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
# the second index is only when there is columns

sub output {

	my ($self ) = @_;

	$self->{parsed} = undef;
	my $i = 0;
	
	for my $line ( @{ $self->{stack} } ) {
		my $j = 0;
		my @values = split (/ /, $line->[1] );
		
		if (scalar @values == 1) {
			print " [$i] @values \n";
		}else {
			for my $column ( @values ) {
				print " [$i,$j] $column ";
				$j++;
			}
			print "\n";
		}
		push @{ $self->{parsed} } , [ @values ];
		$i++;
	}

	$self->{stack} = undef;
}

# just substitute the $\d,\d by the correct
# variable from parsed stack

sub interpolate {

	my ($self, $cmdline ) = @_;

	my $regex = qr/\$(\d+)\,?(\d+)?/; 
	
	while ( $cmdline =~ /$regex/g ){
		$token = $self->{parsed}[$1][$2];
		$cmdline = "$`$token$'";
	}
	return $cmdline;

}

