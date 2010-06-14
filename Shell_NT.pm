package Shell_NT;

use strict;
use warnings;

24; #require

# WRONG!!! it is not supposed to use inh
use base 'Shell_NT::System';

use Data::Dumper;
use Term::ReadLine;
use Class::Inspector;

# Can use multiple modules 
# ideia: prompt -> shell:bla prompt
# etc..

#use Module::Pluggable require => 1;
use Module::Pluggable instantiate => 'new';

# Create a self object for modules
# It contains the actual context
# main stack of data
# main stack of processed data
# version
# other things
#
# The both stacks contains simple data, 
# in case of a scalar, can have a array where
# the first element is the name of this thing
#

sub new {

    my ($class) = @_;

    my $self = {
        version => 'test',
        stack => [ ],
        out_stack => [ ],
    };

    bless $self, $class;

    return $self;

}

sub shell {
	
	my ($self) = @_;

	# Terminal name and prompt should came from
	# it plugin from Start plugins or etc..

    my $terminal = Term::ReadLine->new('Shell NT');
    my $prompt = "#--> ";
    my $OUT = $terminal->OUT || \*STDOUT;

    my $shell_nt = Shell_NT->new();

    while ( defined (my $cmdline = $terminal->readline( $prompt ) ) ) {
           # $shell_nt->dispatch($cmdline);
		   print "$cmdline<\n";
    }
}

sub dispatch {

	my ($self, $cmdline ) = @_;
	
	my ($cmd,@args) = $self->process_cmdline($cmdline);


}


sub process_cmdline {

	my ($self, $cmdline ) = @_;

	#
	# The command is the first 
	#
	
	


}


