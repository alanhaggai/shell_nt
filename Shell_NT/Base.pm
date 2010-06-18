package Shell_NT::Base;

# Luke, I'm your father

24; #require

use strict;
use warnings;

# base for all plugins
# and core modules


sub new {

	my ($class) = @_;

	my $self = {
		stamp => time(),
		context => undef,
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
