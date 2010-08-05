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

#
# This output should be a I/O like something
#


sub output {

	my ($self , $status ) = @_;

	$self->{parsed} = undef;
	my $i = 0;

	return 1 if ! $self->{stack};

	# since the output parser doesn't destroy 
	# the output anymore
	#if ( $status ) {
	#	print map { "$_->[1]\n" } @{ $self->{stack} };
	#	$self->{stack} = undef;
	#	return ;	
	#}

	# add the end \n always
	# The first columns always show just the line number, 
	# The first column is also displayed, and the other 
	# is just by the color change
	# first column (green, white, cyan, white , cyan)
	# check the number of expected output

	my $digits = length scalar @{ $self->{stack} };
	
	for my $line ( @{ $self->{stack} } ) {
		my $j = 0;
		my @values = parse_output( $line->[1] );
		my $columns = scalar @values;
		
		for my $column ( @values ) {
			print color 'blue';
			printf "[%${digits}d] ", $i if $j == 0;
			# check the relevance of the columns (comment, just space, or etc)
			my $color = $self->get_color_for_column ( $j );
			print color $color;
			print $column;
			print color 'reset';
			$j++;
		}
        $j--;
		print color 'blue';
		print "\t[$i,$j]" if $columns > 2;
		print "\n";
		push @{ $self->{parsed} } , [ @values ];
		$i++;
	}
	print color 'reset';

	$self->{stack} = undef;

	return 1;
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
		my $line = $1;
		my $column = $2 || 0;
		my $token = $self->{parsed}[$line][$column];
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

	# now interpolates env vars
	
	my $env = qr/\$(\w+)/;

	while ( $cmdline =~ /$env/g ){
		for my $env_var ( keys %ENV ) {
			next if !( $env_var =~ /^$env$/ );
				my $token = $ENV{$env_var};
				$cmdline = "$`$token$'";
		}
	}

	return $cmdline;

}

sub get_color_for_column {

	my ($self, $index ) = @_;

	return 'green' if $index == 0;

	return $index % 2 ? 'cyan'
					  : 'white';

}

