use constant PI => 3.1415926535;
use aacomp;
use strict;
use constant N => "\n";
use constant T => "\t";

my $target=matrix->read('combi/target.txt');
my $weight=matrix->read('combi/universal inverse variance.txt');
my $method='euclidean';
my $final=$weight->element(0,20);


print 'Tollerable average length? '; my $x=<>;chomp($x);
$weight->element(0,20,$final*$x*0.05/(312-$x));
my ($dna,$aa,$fit)=$target->combicodon(weight=>$weight,boot=>5,method=>$method);
$aa->name('best fit: '.$fit);
$aa->row_el(0,$x.'aa');
$aa->display;
print 'ideal mean: '.$target->element(0,20).N;
print 'targeted mean: '.$x.N;
print 'actual mean: '.int(1/$aa->element(0,20)).N;
print 'actual median: '.int(-log(2)/log(1-$aa->element(0,20))).N;

exit;