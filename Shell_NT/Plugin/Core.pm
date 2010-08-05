package Shell_NT::Plugin::Core;

24; #require

# this modules has the core user functions commands
# the internal core is under Shell_NT::*

use base 'Shell_NT::Base';

use strict;
use warnings;

use Cwd;
use Data::Dumper;

# System enviroment settings

sub env {

	my ($self, $var, @arguments ) = @_;
	
	my $ctx = $self->{ctx};

	if(! $var ) {
		$ctx->add( $_ ) for map { "$_  =  $ENV{$_}\n"  }  keys %ENV;
		$ctx->add( "Above was displayed the enviroment variables" );
		$ctx->output();
	}

	if ( @arguments ) {
		$ENV{$var} = @arguments;
		$ctx->add( "Env $var defined as @arguments" );
	} else {
		undef $ENV{$var};
		$ctx->add( "Env $var undefined");
	}

	$ctx->output();

}



# built-in not to much
# stack of directories 
# for now the history works
# TODO history of chdir

sub cd {

	my ($self, @arguments) = @_;
	
	my $ctx = $self->{ctx};

	my $directory = getcwd();

	my $dir = "@arguments" || $ENV{HOME};

	if (chdir $dir) {
		$ctx->add ( "changed directory to $dir" );
	}
	$ctx->output();
}

# TODO history of chdir

sub dirs {

	return 0;

	my ( $self ) = @_;

	my $ctx = $self->{ctx};

	print Dumper $self->{dir_stack};
	
	$ctx->add ( $_->[1] ) for ( @{ $self->{dir_stack} } );

	$ctx->output();

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


sub show_stack {

    my ($self, @args) = @_;

    my $i = 0;

    print map { $i++ ; ">$i: $_\n" } @{ $self->{ctx}{stack} } ;

}

sub pid {

	# function answer is ... we are asking
	print "My pid is $$\n";

}
