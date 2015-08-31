
use aacomp;
use strict;
use constant N => "\n";
use constant T => "\t";

my $target=matrix->read('combi/target.txt');
my $weight=matrix->read('combi/universal inverse variance.txt');
my $method='euclidean';
$weight->element(0,20,0);

my ($dna,$aa,$fit)=$target->combicodon(weight=>$weight,boot=>20,method=>$method);
$aa->name('best fit: '.$fit);
$aa->display;

$dna->display;

exit;