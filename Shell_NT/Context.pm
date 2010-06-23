package Shell_NT::Context;

use warnings;
use strict;

use Term::ANSIColor;

use Shell_NT::CommandLineParse;

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

	my ($self , $status ) = @_;

	$self->{parsed} = undef;
	my $i = 0;

	if ( $status ) {
		print map { "$_->[1]\n" } @{ $self->{stack} };
		$self->{stack} = undef;
		return ;	
	}
	
	for my $line ( @{ $self->{stack} } ) {
		my $j = 0;
		my @values = parse_cmdline( $line->[1] );
		
		if (scalar @values == 1) {
			print color 'blue' ;
			print "[$i] ";
			print color 'reset';
			print "@values\n";
		}else {
			for my $column ( @values ) {
				print color 'blue';
				print "[$i,$j]" if $j < 3;
				print color 'reset';
				print color 'green' if $j == 0;
				print "\t" if $j == 0;
				print "$column ";
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
#
# Also interpolate the stack
#
# $s\d

sub interpolate {

	my ($self, $cmdline ) = @_;

	my $regex = qr/\$(\d+)\,?(\d+)?/; 
	
	while ( $cmdline =~ /$regex/g ){
		my $token = $self->{parsed}[$1][$2];
		$cmdline = "$`$token$'";
	}

	# we ignore the zero in stack

	my $stack = qr/\$s(\d+)/;
	while ( $cmdline =~ /$stack/g ){
		my $index = $1 - 1;
		# don't exist stack #index
		my $token = $self->{stack}[($1 - 1)];
		$cmdline = "$`$token$'";
	}

	return $cmdline;

}

