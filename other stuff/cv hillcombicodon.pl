use constant PI => 3.1415926535;
use aacomp;
use strict;
use constant N => "\n";
use constant T => "\t";

######## inverse CV as weights

settings->change('ask')=0; # Do not ask anything at all, just deal with it. ps. the depracated lvalue. 


my @tensor;
foreach my $file (<allgenomes/*>) {
	next if $file eq 'info.txt';
	next if -d $file;
	next if $file eq 'inventory.txt';
	my $genome=genome->read($file);
	print "Genome retrieved ${\$genome->species()}\n";
	my $mean=$genome->mean(max=>1,freq=>1)->add_element(1/$genome->avglen(),'Stop');
	$mean->name($genome->species());
	push(@tensor,$mean);
}
my $regrouped=${matrix->regroup(\@tensor)}[0]; # a species per row not per table.
$regrouped->out('combi/all genomes.txt');
my $mom=$regrouped->moments(display=>1);
my $target=$mom->vector(row=>0);
my $weight=$mom->vector(row=>4)->inverse(name=>'inverse of cv',display=>1,out=>'combi/inv of universal cv.txt');
my $method='euclidean';
my ($dna,$aa,$fit)=$target->combicodon(weight=>$weight,boot=>20,method=>$method);
$aa->name('best fit: '.$fit);
$aa->display;
$aa->out('combi/t_mean w_cv '.$method.'.txt');
$aa->out('combi/t_mean w_cv '.$method.' dna.txt');

$weight=$mom->vector(row=>1);
$weight=$weight->elementwise($weight,'*')->inverse(name=>'inverse variance',display=>1,out=>'combi/universal inverse variance.txt');

($dna,$aa,$fit)=$target->combicodon(weight=>$weight,boot=>20,method=>$method);
$aa->name('best fit: '.$fit);
$aa->display;
$aa->out('combi/t_mean w_stscore '.$method.'.txt');
$dna->out('combi/t_mean w_stscore '.$method.' dna.txt');


exit;