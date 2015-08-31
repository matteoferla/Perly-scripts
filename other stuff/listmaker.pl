#!/usr/bin/perl
$a=0;
$file=$ARGV[0];
if (length($file)==0) {print "Missing argument!\n\a";}
open(IN,$file) or die "Can't make file: $!";
$file='>out_'.$file;
open(OUT,$file) or die "Can't make file: $!";
@line=<IN>;
chomp(@line);
for $x (0..$#line) {
	if ($line[$x]=~ m/list\_uids\=(\d*)/mgsi) {
		print OUT "$1\n";
		$a++;
	}
}
print "$a out of $#line\n";
