# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 3;

#01
BEGIN { use_ok( 'Filesys::Type', qw(fstype case) ); }

my $fst = fstype('.');

#02
ok(defined $fst, "Returned an FS type");

#03
ok(defined case('.'), "Case returned something valid");
