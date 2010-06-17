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

# cry for exiting!

sub exit {

	# messages as functions
	print "Oh, goodbye cruel World!\n";
	exit 0;

}


sub set {

	print "set above:\n";
	print Dumper \@_;
    my ($self, @args) = @_;
    print "my ($self, @args) = @_;\n";

    push @{ $self->{ctx}{stack} }, "@args";

    return 0;

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

    return 0;

}

sub pid {

	# function answer is ... we are asking
	print "My pid is $$\n";

}
