#!/usr/bin/perl
use sub;
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';

our $max_code_mut=10;
our $max_pro_mut=10;
our $max_c=0.01;

my $x=0.1;
open(FILE,'>','game_result.txt');

for my $round (0..10) {
	my $ref=mutate($x);
	my $xi=max($ref);
	$x=$ref->[$xi];
	print "Round: $round\tvalue: $x\t".id($xi).N;
}

exit;

sub mutate {
	my @array=();
	my $x=shift;
	$array[0]=$x;
	for my $n (1..$max_code_mut) {$array[$n]=rand($max_c)+$x;}
	for my $n (1..$max_pro_mut) {$array[$n+$max_code_mut]=$x*(1+rand($max_c));}
	return \@array;
}

sub max {
	my @list=@{$_[0]};
	my $max= 0;
	foreach my $n (0..$#list) {
	    $max = $n if $list[$max] < $list[$n];
	}
	return $max;
}

sub id {
	my $i=shift;
	if ($i==0) {return 'Original';}
	elsif ($i <= $max_code_mut) {return 'Coding';}
	elsif ($i <= ($max_code_mut+$max_pro_mut)) {return 'Promoter';}
	else {return 'Error';}
}