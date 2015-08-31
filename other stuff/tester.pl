use aacomp;
my $genome=genome->fasta('demo/E.coli.fasta');
my $matrix=matrix->zeros($genome->size(),0);
for my $n (0..$genome->size()) {
	$matrix->element($n,0,length($genome->seq($n)));
}
$matrix->out('test.txt');


__END__