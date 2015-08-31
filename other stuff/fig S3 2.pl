use aacomp;   # call the core
use strict;
use warnings;

settings->get('ask',0); #no questions asked. Redundant as unless parameters are omitted settings file is actually not used.
my $table=matrix->zeros(19,0); # Make a 20 x 1 matrix...
$table->rowhead(settings->alphabet()); #with rows named after each amino acid
$table->name('Asymetric involvement of each amino acid'); #with a name of sorts
$table->colhead([qw(dipeptide tripeptide)]); #with column header

my $genome=genome->fasta('demo/E.coli.fasta');

##This is the faster way of doing it.

for my $k (2..5) {
	my ($mean)=$genome->mean(max=>$k,freq=>1); #k=2, label by names, local frequencies 20aa Alphabet is taken from settings.
	my @asy=map(0,0..$mean->size(2)); # preallocate
	for my $index (0..$mean->size(2)) {
		$asy[$index]=$mean->_special_sub_asymmetry($index); #the actual function genome->stats uses.
	}  
	
	my @col=@{$mean->colhead()}; # get row labels
	for my $index (0..19) { # loop through each standard amino acid 
		my $letter=${settings->alphabet()}[$index]; #alphabet does not contain B, X, J, O, U or fancy accented letters
		my $distance=0; # preallocation
		for my $index (grep($col[$_]=~/$letter/,0..$#col)) { #loop through all the columns with amino acid $letter
			$distance+=$asy[$index]**2;  # euclidean mean. Why?
		}
		$table->element($index,$k-2,sqrt($distance));
	}
	print "$k-mers done\n";
}
$table=$table->rank(0);
$table->out('fig S3 table.txt');

print "AAll done\n\a";
exit;


__END__
#slower way as it calculates other metrics including predicted values etc.

for my $k (2..3) {
	my ($stats)=$genome->stats($k,'name',1); #k=2, label by names, local frequencies 20aa Alphabet is taken from settings.
	$stats=$stats->transpose(); # flip the table so it can be sorted by asymetry
	$stats=$stats->rank(11); # 11th column is asymetry
	$stats->out('figure S3 table additional '.$k.'.txt');
	my @row=@{$stats->rowhead()}; # get row labels
	for my $index (0..19) { # loop through each standard amino acid 
		my $letter=${settings->alphabet()}[$index]; #alphabet does not contain B, X, J, O, U or fancy accented letters
		my $distance=0; # preallocation
		for my $n (grep($row[$_]=~/$letter/,0..$#row)) { #loop through all the rows with amino acid $letter
			$distance+=$stats->element($n,11)**2;  # euclidean mean. Why?
		}
		$table->element($index,0,sqrt($distance/20)); # divide?
	}
}
$table->rank(0);
$table->out('fig S3 table.txt');

print "All done\n\a";
exit;
