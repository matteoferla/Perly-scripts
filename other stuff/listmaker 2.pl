#!/usr/bin/perl


$file='proks.txt';
open(PROKS,$file) or die "Can't make file: $!";
$file='>prok2.txt';
open(PROKO,$file) or die "Can't make file: $!";
@line=<PROKS>;
chomp(@line);
for $x (0..$#line) {
	if ($line[$x]=~ m/a title=\"ProtTable\" href=\"(.*?)\"/mgsi) {
		print PROKO "$1\n";
		$a++;
	}
}
print "$a out of $#line\n";
