use constant PI => 3.1415926535;
use aacomp;
use strict;
use constant N => "\n";
use constant T => "\t";

######## incresingly heavy stop

my $target=matrix->read('demo/E.coli stats.txt')->vector(row=>0)->add_element(1/300,'Stop',display=>1);

open my $handle,'>','stopped at stop.txt';
print $handle 'weight'.T.'fitted'.T.join(T,qw(Ala Cys Asp Glu Phe Gly His Ile Lys Leu Met Asn Pro Gln Arg Ser Thr Val Trp Tyr stop)).N;

for my $lin (0..100) {
	my $n=20*$lin/(100-$lin);  #equally spaced after normalising.
	my $weight=matrix->fill(0,20,1);
	print 'Zero has weight '.$n."\n";
	$weight->element(0,20,$n);
	my ($dna,$aa,$fit)=$target->combicodon(weight=>$weight,boot=>2,method=>'euclid',verbose=>0);
	$aa->name('best fit: '.$fit);
	$aa->display;
	print $handle $n.T.$fit;
	print $handle T.$aa->element(0,$_) for (0..$aa->size(2));
	print $handle N;
}


close $handle;