use aacomp;   # call the core
use strict;
use warnings;

my $intervals=100;
my $set=20;

settings->get('ask',0); #no questions asked. Redundant as unless parameters are omitted settings file is actually not used.
my $genome=genome->fasta('demo/E.coli.fasta'); #read fasta
my $freq=$genome->freq(max=>1,gene_tag=>'name',freq=>1,stop=>1); #k=1, label by names, local frequencies 20aa Alphabet is taken from settings.
my $dist=$freq->distributions($intervals); # calculates the distributions (a form of crosstabulation) in $intervals intevals
$dist->out('normality/dist table.txt');
my $mean=$dist->moments->vector(row=>6); # this is the maximum value.
for my $m (0..$dist->size(1)) {
	for my $n (0..$dist->size(2)) {
		$dist->element($m,$n,$dist->element($m,$n)/$mean->element(0,$n));
	}
}
#now the mean has p of 1.

my $stats=$freq->moments();
my $gauss=matrix->zeros($intervals,$set); #make a copy of dist with zeros.

for my $n (0..$set) {
	for my $m (0..$intervals) {
		$gauss->element($m,$n,exp(-0.5*(($m/$intervals-$stats->element(0,$n))/$stats->element(1,$n))**2));
	}
}
$gauss->out('normality/pred table.txt');


my $rsquared=matrix->zeros(0,$set,name=>'Coefficients of determination',colhead=>$dist->colhead,rowhead=>[('R2')]);
for my $n (0..$set) {
	my $obs=$dist->vector(col=>$n)->transpose;
	my $exp=$gauss->vector(col=>$n)->transpose;
	$rsquared->element(0,$n,$obs->coeff_determination($exp));
}
$rsquared->out('normality/rsquared.txt');

$rsquared->row_append($dist->moments->vector(row=>0))->transpose->rank(1)->out('normality/rsquared sorted by size.txt');







print "All done\n\a";
exit;