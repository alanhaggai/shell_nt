#!/usr/bin/perl -w

#
# Simple test for listsubs by regex 
#

use strict;

use lib '../';

use Test::More;

my @subs = qw/carilho foo bar space_lab opop/;  
my @all = ( @subs, "_internal", "_restrict" );


