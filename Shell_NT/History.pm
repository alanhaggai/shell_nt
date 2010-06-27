package Shell_NT::History;

# Package that controls the history of typed 
# commands and arguments of this shell
# 

24; #require

use strict;
use warnings;
use Data::Dumper;

use Shell_NT::Know;

#
# new: I receive a shell, and add myself on it
# or simple return a new shell
#

sub new {

	my ($class, $shell) = @_;

	# zero when $shell is not a shell
	# hardcoded shell history file name
	
	my $root = Shell_NT::Know->get_root();

	my $self = {
		history => [ ],
		file => "$root/.shell_nt_history",
	};

	bless $self, $class;

	$self->load_history();

	# removes old history in case that we
	# already have one, maybe save it?
	
	$shell->{history} = $self if $shell;
	
	# zero when error
	return $self;

}

# there is a obvius bug that we do not support 
# save history from more than one instance

sub load_history {
	
	my ($self ) = @_;

	if (-e $self->{file} ) {

		open my $fh, "<", $self->{file};
			while ( my $historical = <$fh>) {
				$historical =~ m/
								(\d+)\t
								(\w)\t
								(\d+)\t
								(.*)
								/x;
				push @{ $self->{history} }, [ $1, $2 , $3, $4 ];
			}
		close $fh;
	
		print "Looks that we recover the history from $self->{file}\n";
	} else {
		print "Starting a new history file in $self->{file}\n";
	}

}

# save the history in a file
# do it manually, maybe we are in sig_int or like

sub DESTROY {

	my ( $self ) = @_;

	open my $fh , ">" , $self->{file};
		for my $register ( @{ $self->{history} } ){
			chomp $register;
			print $fh map { "$_\t" } @$register if $register;
			print $fh "\n";
		}
	close $fh;

	#mmm, messages as functions
	print "Looks that we saved the history at $self->{file}\n";
}

# Adds a entry to history

sub push {

	my ($self, $type, $status, $cmdline) = @_;

	my $epoch = time();
	
	push @{ $self->{history} }, [ $epoch, $type, $status, $cmdline ];

}

sub all_commands {

	my ( $self ) = @_;

	return map { $_->[-1] } @{ $self->{history} };

}

sub all {
	
	my ( $self ) = @_;

	return @{ $self->{history} };

}
