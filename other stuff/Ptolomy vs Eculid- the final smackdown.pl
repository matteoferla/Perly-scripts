
use aacomp;
use strict;
use constant N => "\n";
use constant T => "\t";

#### Ptholomy vs Eculid: the final showdown
my $target=matrix->read('demo/E.coli stats.txt')->vector(row=>0,name=>'target')->add_element(1/300,'Stop',display=>1);
my (%dna,%aa,$fit)=();

for my $method qw(cosine euclid) {
	($dna{$method},$aa{$method},$fit)=$target->combicodon(boot=>9,method=>$method,verbose=>0);
	$aa{$method}->options(name=>$method.' method. best fit: '.$fit,display=>1);
}


$target->out('PvE target.txt');
$aa{$_}->out('PvE '.$_.'.txt') for qw(cosine euclid);

print sub::header('conclusions');
for my $method qw(cosine euclid) {print $method.'-obtained. cosine distance... '.$aa{$method}->cosine_distance($target).N;}
for my $method qw(cosine euclid) {print $method.'-obtained. Eclidean distance... '.$aa{$method}->euclidean_distance($target).N;}
exit;