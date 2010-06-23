#!/usr/bin/perl
#
# Basic Tests for Know
#

# workaround for now
use lib '../';
use Test::More;

plan tests => 10;

use_ok("Shell_NT::Know");

Shell_NT::Know->define_root("./");

my $know = Shell_NT::Know->new("ACDC");

ok ( -e "./ACDC/know" , "created config" );

my $music = "black in back";

$know->{know}->{music} = $music;

ok ( $know->{know}{music} eq $music, "Defined the information");

undef $know;

my $cover = Shell_NT::Know->new("ACDC");

ok ( $cover->{know}{music} eq $music , "We can play cover");

ok ( $cover->define_root("/tmp") == undef , "Objects can not redifine root");

undef $cover;

# Nested data

ok ( Shell_NT::Know->define_root("./Nested") eq "./Nested" , "New Root for nested tests");

my $nested = Shell_NT::Know->new("Hulk/iPhone");

ok ( -e "./Nested/Hulk/iPhone/know" , "created config" );

my $toomuchdeep = { 

	artist => "ACDC",
	album => "all rock",
	style => {
				foo => "bar",
				mimimi => "mimimim",

			},
	array => [ 0, 1, 2, 3, 4, 5 ],
};

$nested->{know}{artist} = "ACDC";
$nested->{know}{album} = "all rock";
$nested->{know}{style}{foo} = "bar";
$nested->{know}{style}{mimimi} = "mimimim";

for ( 0 .. 5 ){
	push @{ $nested->{know}{array} } , $_;
}

is_deeply ( $nested->{know} , $toomuchdeep , "Is really deep");

# lets save

$nested->save();

my $nested_saved = Shell_NT::Know->new("Hulk/iPhone");

is_deeply ( $nested_saved->{know} , $toomuchdeep , "Is really deep");

# sub modules 
#

use Shell_NT::History;

my $test = Shell_NT::History->new();

ok ($test->{file} eq "./Nested/.shell_nt_history", "$test->{file} ?");
