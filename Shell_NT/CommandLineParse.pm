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

my $truespace = qr/$not\s+/;

my $singlequote = qr/$not\'/;
my $doublequote = qr/$not\"/;

sub parse_cmdline {
	
	my $cmdline = shift;

	# primary token is a *non-meta-space*
	my @stack = ();

	while ( $cmdline ){
		my $string;
		$cmdline =~ /$doublequote|$truespace|$singlequote/;
		my $pre = $`;
		my $sep = $&;
		my $pos = $';

		if ( ! $sep ) {
			push @stack, $cmdline;
			last;
		}
		if ( $sep =~ /$truespace/ ){
			push @stack , $pre if $pre;
			$cmdline = $pos;
			next;
		}
		if ( $sep =~ /$doublequote/ ) {
			($cmdline ,$string) = quoted( $doublequote, $pre, $sep, $pos);
			push @stack , $string;
			next;
		}
		if ( $sep =~ /$singlequote/ ) {
			($cmdline ,$string) = quoted( $singlequote, $pre, $sep, $pos);
			push @stack , $string;
			next;
		}

	 
	}

	return @stack;

}

# It is supposed to quote always be the begin of 
# token, so for now we ignore the pre match

sub quoted {

	my ( $quote, $pre, $sep, $pos ) = @_;

	my $string = $sep;

	$pos =~ /$quote/;
	$pre = $`;
	$sep = $&;
	$pos = $';

	$string .= "$pre$sep";

	return $pos, $string;

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

