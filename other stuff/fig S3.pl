use aacomp;   # call the core
use strict;
use warnings;
use constant T=>"\t";
use constant N=>"\n";

settings->get('ask',0); #no questions asked. Redundant as unless parameters are omitted settings file is actually not used.
my $table=matrix->zeros(19,0); # Make a 20 x 1 matrix...
$table->rowhead(settings->alphabet()); #with rows named after each amino acid
$table->name('Asymetric involvement of each amino acid'); #with a name of sorts
$table->colhead([qw(dipeptide tripeptide tetrapeptide)]); #with column header

my $genome=genome->fasta('demo/E.coli.fasta');

##This is the faster way of doing it.

for my $k (2..4) {
	my $handle=sub::handle('S3 asy k'.$k.'.txt');
	my ($mean)=$genome->mean(max=>$k,freq=>1); #k=2, label by names, local frequencies 20aa Alphabet is taken from settings.
	my @asy=map(0,0..$mean->size(2)); # preallocate
	for my $index (0..$mean->size(2)) {
		$asy[$index]=$mean->_special_sub_asymmetry($index); #the actual function genome->stats uses.
		print $handle $mean->col_el($index).T.$asy[$index].N;
	}
	close $handle;
	
	my @col=@{$mean->colhead()}; # get row labels
	for my $index (0..19) { # loop through each standard amino acid 
		my $letter=${settings->alphabet()}[$index]; #alphabet does not contain B, X, J, O, U or fancy accented letters
		my ($distance,$total)=(0,0); # preallocation
		for my $index (grep($col[$_]=~/$letter/,0..$#col)) { #loop through all the columns with amino acid $letter
			$distance+=$asy[$index]**2;  # euclidean mean. Why?
			$total++;
		}
		$table->element($index,$k-2,sqrt($distance/$total));
	}
	print "$k-mers done\n";
}
$table=$table->rank(0);
$table->out('fig S3 table.txt');

print "All done\n\a";
exit;
