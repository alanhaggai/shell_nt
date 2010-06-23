package Shell_NT::Base;

# Luke, I'm your father

24; #require

use strict;
use warnings;

use Shell_NT::Know;

# base for all plugins
# and core modules


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

	return $self;

}

# end base for all#

sub attach {

	my ( $self, $shell ) = @_;

	$self->{shell} = $shell;

	$self->{ctx} = $shell->{ctx};

}

sub detach {

	my ($self) = @_;

	delete $self->{shell};
	delete $self->{ctx};
	
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
