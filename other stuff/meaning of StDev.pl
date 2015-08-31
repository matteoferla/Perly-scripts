use aacomp;

my $genome=genome->read('ecoli.txt');
my $out='';
for my $n (1..10) {
	my $letter='A'x$n;
	eval '$out.="$letter ".(${[$genome->letter($letter)]}[1]/${[$genome->letter($letter)]}[0])."\n";'
}
print $out;
