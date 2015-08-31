#!/usr/bin/perl

use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";
use constant S=>' ';


unlink 'temp';   # delete file temp
open FILE, "+>>temp";
binmode FILE;

my @array;
my @yarra;
for my $n (0..9) {
	$array[$n]=hd($n,rand());
}

my $n=sub{hd(4)};

print $n.N;


exit;


sub hd {
	my ($index,$new)=@_;
	if ($new) {
		seek (FILE,$index*4,0);
		syswrite FILE,(pack "f", $new);
	}
	else {
		my $data;
		seek(FILE,($index*4),0);
		die 'error' if not sysread(FILE,$data,4,0);
		$new=unpack "f", $data;
	}
	return $new;
}

sub size {
	my @size=<FILE>;
	print 'SIZE:'.length(join('',@size)).N;

}

sub diff {
	return int(100*($_[1]-$_[0])/$_[1]).'%';
}






