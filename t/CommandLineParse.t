#!/usr/bin/perl
#
#
# Simple Test for command line parsing
#

# workaround for now
use lib '../';
use Test::More;

# first element: cmdline
# other expected cmd/args

my $tests = [
	[ "ls", 'ls'  ],
	[ "ls -ls", 'ls', '-ls'],
	[ 'ls "foo bar" -ls', ls, '"foo bar"',  '-ls'],
	[ 'perl -e \'sleep 10\'', 'perl', '-e', "'sleep 10'" ],
	[ '/usr/bin/ls /', '/usr/bin/ls', '/'],
	[ '/home\ with\ spaces/frederico/command foo bar', '/home\ with\ spaces/frederico/command', "foo", "bar"],
	[ '"/usr/ bin/ls" /fo\ o  \' \'', '"/usr/ bin/ls"', '/fo\ o',"' '"],
];

plan tests => ( scalar @$tests ) * 2 + 1;

use_ok("Shell_NT::CommandLineParse");

for my $cmdline ( @{ $tests } ) {

	diag "now: $cmdline->[0]\n";
	my ( $command, @arguments ) = parse_cmdline( $cmdline->[0] );

	ok ( $command eq $cmdline->[1] , "Command ok: $command");
	is_deeply ( [ $cmdline->[0], $command, @arguments ] , $cmdline , "all arguments: @arguments");

}
