package Shell_NT::Plugin::Reload;

24; #require

use base 'Shell_NT::Plugin::Base';

use strict;
use warnings;

use POSIX qw/setsid/;

#
# Reload, spawns a child process and re-run 
# this shell (should be)
# 
# In future it is supposed to save contexts and 
# save the data and load for the code reboot
#
# Maybe keep the father alive until everything 
# is ok, "who wants.. to live .. forever..."

sub reload {

	my ($self) = @_;
	print "$0\n";
	exec( "$0" );

}


__END__
=head1
	print "old pid: $$\n";

	my $pid = fork;
	
	if ($pid) {

	print "In future I'll look for my son, but now I just trust in evolution\n";

	exit;

	}else {

	my $leader = setsid or die "Can't reload myself!\n";

	print "It is very hard, when our children grow, but I want to go through my own path\n";

	#Posix::setsid() or die "Can't reload myself!\n";

	print "new pid: $$ leader $leader\n";

	exec("vim");
	
	for ( 0 .. 100 ) {
		sleep 1;
		print "$_ ";
	}

	print "\n";
	
	}
	
}
=cut
