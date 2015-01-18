#!/usr/bin/perl

# ==========================================================================
use strict;
use warnings;

# ==========================================================================
use Test::More; # tests => 6;

# ==========================================================================
BEGIN { use_ok( 'Parse::MAL' ); }

# ==========================================================================
can_ok('Parse::MAL', 'new');

# ==========================================================================
my $parser = Parse::MAL -> new();

# ==========================================================================
isa_ok($parser, 'Parse::MAL');
isa_ok($parser, 'Parse::Yapp::Driver');

# ==========================================================================
can_ok($parser, 'process');
can_ok($parser, 'get_errors');

# ==========================================================================
my ($input, $output, $expected);

# ==========================================================================
# Basic test as string
# ==========================================================================
$input    = 'ac := ac + 1;';
$expected = '0  0 0  0 0  0 0  0  0  0  0  1  0 0 0 1  0 0 0 1  0 1 1 0  0 0 0 0 0 0 0 0';
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ with direct string');

# ==========================================================================
$input    = 'ac := ac + 1; if n then goto 4;';
$expected = '0  0 1  0 0  0 0  0  0  0  0  1  0 0 0 1  0 0 0 1  0 1 1 0  0 0 0 0 0 1 0 0';
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ and goto with direct string');

# ==========================================================================
$input    = "ac := ac + 1;\nac := ac + 1;\n";
$expected = '0  0 0  0 0  0 0  0  0  0  0  1  0 0 0 1  0 0 0 1  0 1 1 0  0 0 0 0 0 0 0 0';
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, '2 x ac++ with direct string');

# ==========================================================================
$input    = "ac := \nac + 1;";;
$expected = '0  0 0  0 0  0 0  0  0  0  0  1  0 0 0 1  0 0 0 1  0 1 1 0  0 0 0 0 0 0 0 0';
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ split in two lines');

# ==========================================================================
# Basic test as binary
# ==========================================================================
$parser -> want_binary();

# ==========================================================================
$input    = 'ac := ac + 1;';
$expected = 0b00000000000100010001011000000000;
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ with direct string');

# ==========================================================================
$input    = 'ac := ac + 1; if n then goto 4;';
$expected = 0b00100000000100010001011000000100;
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ and goto with direct string');

# ==========================================================================
$input    = "ac := ac + 1;\nac := ac + 1;\n";
$expected = 0b00000000000100010001011000000000;
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, '2 x ac++ with direct string');

# ==========================================================================
$input    = "ac := \nac + 1;";;
$expected = 0b00000000000100010001011000000000;
$output   = '';
$parser -> process(\$input, \$output);
is($output, $expected, 'ac++ split in two lines');

# ==========================================================================
done_testing();

# ==========================================================================

