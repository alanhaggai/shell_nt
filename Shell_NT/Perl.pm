package Shell_NT::Perl;

#
# This package is a perl evaluator
# more or less inspired by gists 
# from git hub
#

24; #require

use strict;
use warnings;

use File::Temp qw/ tempfile /;
use Data::Dumper;

#
# Each gist is a tmp file, that can be saved in other way
# inside of program, the gist has it number
#

sub new {

	my ( $class ) = @_;

	my $self = {
		
		gists => [ ],
		
	};
	
	bless $self, $class;
	
}

# simple create a tmp file, 
# and returns its name and push 
# in gists array
# the file handle is "write only"
# if necessary close it and open again

sub create_gist {

	my ( $self ) = @_;
	my ( $fh , $filename ) = tempfile();
	#close $fh;

	push @{ $self->{gists} } , $filename;

	return $fh, ( scalar @{ $self->{gists} } - 1 );

	# create a package gist namespace

}

# B?
sub syntax {

	my ( $self, $gist ) = @_;
	
	if ( -e $self->{gists}[$gist] ) {
		my $check = system("perl -c $self->{gists}[$gist]");
		return 1 if ! $check;
	}
	
	print "Error code block $gist \n";
	return 0;
}

# B something?

sub run_gist {

	my ( $self, $gist, $debug ) = @_ ;
	
	if ( -e $self->{gists}[$gist] ) {
		# run 
		my $run = system ("perl $debug $self->{gists}[$gist]");
		return 1 if ! $run;
	}
	return 0;
}
