#!/usr/bin/env perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

=head1 NAME

perl.pl - example of some perl for nanorc formatting

=head1 SYNOPSIS

	example code

Explanation

=cut

use v5.20.0; # vstrings! also we can now use...

our $postfix = [q~deref~];
print $postfix->$@;
print $postfix->$#*;
print @{ $circumfix };
print @$prefix;
print @$$$prefix;
print $#{ $circumfix };
print $#$prefix;
print %{ $circumfix->{'nested'} };

# var $names should not be 'highlighted' in @comments 
# but it's not crucial.

warn qq`but they are in $a qq string &unless \$escaped`
  . "nor can #comments begin in strings";

die q!No $^W! unless $^W;

{
	package Acme::Misc;#comments can appear after lines
	use Data::Dumper 0.2;
	print Dumper \%-; # todo: it is tricky to distinguish between escapes and references
	1;
}

my %numbers = (
	one   =>    1,
	two   =>    2.0,
	three => 0b11,
	four  =>    4e0,
	five  =>    5.0e0,
	ten   => 0x0a,
);

sub salami_slice ($) {
	my $recursive;
	$recursive = sub {
		__SUB__->(chop $_[0]);
	}->(&shift);
	... # todo...
}

my $bindir = FindBin::again();

ITEM: foreach my $item (sort { fc $a cmp fc $b } map {"$_..."} qw{ $these %words @are not interpolated }) {
	local $_ = lcfirst "$item\n";
	s/[\$\%\@]//g; # these lines do
	y{$%@}    {}d; # the same thing
	tr{$%@}{   };  # this does not
	s~\cK~~g;      # something different again

	print qq(\s) for 1..10;
	print qq(\s) x 10;
	print uc ${^MATCH} if /\x74|\N{LATIN LETTER T}|\x{0074}/p;
}

print 'Escapes like \n are not interpolated in single quotes' =~ tr/\s/ /; # but they are in transliterations

# todo: heredocs are really hard
say <<HEREDOC;

it's a 
HEREDOC

0 and 'finally';

__DATA__

Anything after this is plain text!
It can be read with <DATA>
