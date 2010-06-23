package Shell_NT::Know;

#
# Configuration and Data Handler
# for Modules and Plugins
#

#
# One day I will be the AI of this!
# 

use warnings;
use strict;

use File::Path qw( make_path );

# Data Sources
use Config::General;


# Sources Config

my $root = undef;

# very simple for now,
# receive the "root" dir 
# The 1st version uses Config::General
#
# Name is the last name of code
# ex. Plugin/foo or History 
#


sub new {

	my ($class, $name) = @_;

	# bootstrap 
	my $filename = "$root/$name/know";
	
	if ( ! -w $filename ) {
		make_path "$root/$name";
		open my $fh, ">", $filename;
		close $fh;
	}
	my $access = Config::General->new( $filename );

	my $self = {
		version  => 1,
		filename => $filename,
		access => $access,
		know => { $access->getall },
	};

	return bless $self, $class;

}

# mmm who is authorized to changed it?
# should now be a object

sub define_root {

	my ( $class, $new_root ) = @_;
	
	return undef if ref $class;
	
	$root = $new_root;
	
	return $root;
}

# timer triggered?

sub save {
	
	my ( $self ) = @_;
	
	$self->{access}->save_file(
		$self->{filename},
		$self->{know}
		);
	
}

# we would like to remember

sub DESTROY {

	my ( $self ) = @_;

	$self->{access}->save_file(
		$self->{filename},
		$self->{know}
		);

}

24; #require

