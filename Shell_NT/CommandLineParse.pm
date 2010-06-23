package Shell_NT::CommandLineParse;

use strict;
use warnings;

use Data::Dumper;

BEGIN {

	use Exporter ();
	our ( $VERSION, @ISA, @EXPORT, @EXPORT_OK, @EXPORT_TAGS );

	$VERSION = 1.00;

	@ISA = qw(Exporter);
	@EXPORT = qw ( &parse_cmdline );
	@EXPORT_TAGS = ( );

	@EXPORT_OK = ( );

}

# Globals constants, with lower case, yes lower case

my $not = qr/(?<!\\)/;

my $truespace = qr/$not\s/;

my $singlequote = qr/$not\'/;
my $doublequote = qr/$not\"/;

sub parse_cmdline {
	
	my $cmdline = shift;

	# primary token is a *non-meta-space*
	my @stack = ();

	while ( $cmdline ){
		$cmdline =~ /$doublequote|$truespace|$singlequote/;
		my $pre = $`;
		my $sep = $&;
		my $pos = $';

		if ( ! $sep ) {
			push @stack, $cmdline;
			last;
		}
		if ( $sep eq " " ){
			push @stack , $pre;
			$cmdline = $pos;
			next;
		}
		if ( $sep =~ /$doublequote/ ) {
			my $string = "$pre$sep";
			$cmdline = $pos;
			$cmdline =~ /$doublequote/ ; 
			$string .= "$`$&";
			$cmdline = $';
			push @stack , $string;
			next;
		}
	
	}

	return @stack;

}


24; #require

__DATA__
tmp parser:
		if ($cmdline =~ /$doublequote/) {
			$DB::single = 1;
			my $string .= "$`$&";
			$cmdline = $';
			$cmdline =~ /$doublequote/;
			$string .= "$`$&";
			$cmdline = $';
			push @stack, $string;
			next;
		}
		 
		if ($cmdline =~ /$truespace/ ){
			push @stack , $`;
			$cmdline = $';
			next;
		}

		push @stack, $cmdline;
		$cmdline = undef;

